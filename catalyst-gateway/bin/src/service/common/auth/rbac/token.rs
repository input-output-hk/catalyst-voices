//! Catalyst RBAC Token utility functions.

// cspell: words rsplit Fftx

use std::{
    fmt::{Display, Formatter},
    sync::LazyLock,
    time::Duration,
};

use anyhow::{Context, Result, anyhow};
use base64::{Engine, prelude::BASE64_URL_SAFE_NO_PAD};
use cardano_chain_follower::Network;
use catalyst_types::catalyst_id::{CatalystId, key_rotation::KeyRotation, role_index::RoleId};
use chrono::{TimeDelta, Utc};
use ed25519_dalek::{Signature, VerifyingKey};
use rbac_registration::registration::cardano::RegistrationChain;
use regex::Regex;

use crate::{rbac::latest_rbac_chain, settings::Settings};

/// Captures just the digits after last slash
/// This Regex should not fail
#[allow(clippy::unwrap_used)]
static REGEX: LazyLock<Regex> = LazyLock::new(|| Regex::new(r"/\d+$").unwrap());

/// A Catalyst RBAC Authorization Token.
///
/// See [this document] for more details.
///
/// [this document]: https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md
#[derive(Debug, Clone)]
pub(crate) struct CatalystRBACTokenV1 {
    /// A Catalyst identifier.
    catalyst_id: CatalystId,
    /// A network value.
    ///
    /// The network value is contained in the Catalyst ID and can be accessed from it, but
    /// it is a string, so we convert it to this enum during the validation.
    network: Network,
    /// Ed25519 Signature of the Token
    signature: Signature,
    /// Raw bytes of the token without the signature.
    raw: Vec<u8>,
    /// A corresponded RBAC chain, constructed from the most recent data from the
    /// database. Lazy initialized
    reg_chain: Option<RegistrationChain>,
}

#[derive(thiserror::Error, Debug)]
pub(crate) enum VerificationError {
    /// Not a Admin RBAC token
    #[error("Not a valid Admin RBAC token")]
    NotAdmin,
    /// Registration chain cannot be found.
    #[error("Registration not found for the auth token.")]
    RegistrationNotFound,
    /// Latest signing key cannot be found.
    #[error("Unable to get the latest signing key.")]
    LatestSigningKey,
    /// Invalid RBAC token signature
    #[error("Invalid RBAC Token signature.")]
    InvalidSignature,
}

impl CatalystRBACTokenV1 {
    /// Bearer Token prefix for this token.
    const AUTH_TOKEN_PREFIX: &str = "catid.";

    /// Creates a new token instance.
    #[cfg(test)]
    pub(crate) fn new(
        network: &str,
        subnet: Option<&str>,
        role0_pk: VerifyingKey,
        sk: &ed25519_dalek::SigningKey,
    ) -> Result<Self> {
        use ed25519_dalek::ed25519::signature::Signer;

        let catalyst_id = CatalystId::new(network, subnet, role0_pk)
            .with_nonce()
            .as_id();
        let network = convert_network(&catalyst_id.network())?;
        let raw = as_raw_bytes(&catalyst_id.to_string());
        let signature = sk.sign(&raw);

        Ok(Self {
            catalyst_id,
            network,
            signature,
            raw,
            reg_chain: None,
        })
    }

    /// Parses a token from the given string.
    ///
    /// The token consists of the following parts:
    /// - "catid" prefix.
    /// - Nonce.
    /// - Network.
    /// - Role 0 public key.
    /// - Signature.
    ///
    /// For example:
    /// ```
    /// catid.:173710179@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE.<signature>
    /// ```
    pub(crate) fn parse(token: &str) -> Result<CatalystRBACTokenV1> {
        let token = token
            .strip_prefix(Self::AUTH_TOKEN_PREFIX)
            .ok_or_else(|| anyhow!("Missing token prefix"))?;
        let (token, signature) = token
            .rsplit_once('.')
            .ok_or_else(|| anyhow!("Missing token signature"))?;
        let signature = BASE64_URL_SAFE_NO_PAD
            .decode(signature.as_bytes())
            .context("Invalid token signature encoding")?
            .try_into()
            .map(|b| Signature::from_bytes(&b))
            .map_err(|_| anyhow!("Invalid token signature length"))?;
        let raw = as_raw_bytes(token);

        let catalyst_id: CatalystId = token
            .parse()
            .inspect_err(|e| tracing::error!(e = ?e, id=token, "Cannot parse catalyst id"))
            .context("Invalid Catalyst ID")?;
        if catalyst_id.username().is_some_and(|n| !n.is_empty()) {
            return Err(anyhow!("Catalyst ID must not contain username"));
        }
        if catalyst_id.is_uri() {
            return Err(anyhow!("Catalyst ID cannot be in URI format"));
        }
        if catalyst_id.nonce().is_none() {
            return Err(anyhow!("Catalyst ID must have nonce"));
        }

        if REGEX.is_match(token) {
            return Err(anyhow!(
                "Catalyst ID mustn't have role or rotation specified"
            ));
        }
        let network = convert_network(&catalyst_id.network())?;

        Ok(Self {
            catalyst_id,
            network,
            signature,
            raw,
            reg_chain: None,
        })
    }

    /// Return the latest signing public key for the provided role.
    /// If the its an admin RBAC token, returns associated Admin public key.
    pub(crate) async fn get_latest_signing_public_key_for_role(
        &mut self,
        role: RoleId,
    ) -> Result<(VerifyingKey, KeyRotation)> {
        let res = if self.catalyst_id.is_admin() {
            Settings::admin_cfg()
                .get_admin_key(&self.catalyst_id, role)
                .ok_or(VerificationError::NotAdmin)?
        } else {
            let reg_chain = self
                .reg_chain()
                .await?
                .ok_or(VerificationError::RegistrationNotFound)?;
            reg_chain
                .get_latest_signing_public_key_for_role(role)
                .ok_or_else(|| {
                    tracing::debug!(
                        "Unable to get last signing key for {} Catalyst ID",
                        self.catalyst_id
                    );
                    VerificationError::LatestSigningKey
                })?
        };

        Ok(res)
    }

    /// Given the `PublicKey`, verifies the token was correctly signed.
    pub(crate) async fn verify(&mut self) -> Result<()> {
        let public_key = self
            .get_latest_signing_public_key_for_role(RoleId::Role0)
            .await?
            .0;

        Ok(public_key
            .verify_strict(&self.raw, &self.signature)
            .map_err(|_| VerificationError::InvalidSignature)?)
    }

    /// Checks that the token timestamp is valid.
    ///
    /// The timestamp is valid if it isn't too old or too skewed.
    pub(crate) fn is_young(
        &self,
        max_age: Duration,
        max_skew: Duration,
    ) -> bool {
        let Some(token_age) = self.catalyst_id.nonce() else {
            return false;
        };

        let now = Utc::now();

        // The token is considered old if it was issued more than max_age ago.
        // And newer than an allowed clock skew value
        // This is a safety measure to avoid replay attacks.
        let Ok(max_age) = TimeDelta::from_std(max_age) else {
            return false;
        };
        let Ok(max_skew) = TimeDelta::from_std(max_skew) else {
            return false;
        };
        let Some(min_time) = now.checked_sub_signed(max_age) else {
            return false;
        };
        let Some(max_time) = now.checked_add_signed(max_skew) else {
            return false;
        };
        (min_time < token_age) && (max_time > token_age)
    }

    /// Returns a Catalyst ID from the token.
    pub(crate) fn catalyst_id(&self) -> &CatalystId {
        &self.catalyst_id
    }

    /// Returns a network.
    #[allow(dead_code)]
    pub(crate) fn network(&self) -> &Network {
        &self.network
    }

    /// Returns a corresponded registration chain if any registrations present.
    /// If it is a first call, fetch all data from the database and initialize it.
    pub(crate) async fn reg_chain(&mut self) -> Result<Option<RegistrationChain>> {
        if self.reg_chain.is_none() {
            self.reg_chain = latest_rbac_chain(&self.catalyst_id).await?.map(|i| i.chain);
        }
        Ok(self.reg_chain.clone())
    }
}

impl Display for CatalystRBACTokenV1 {
    fn fmt(
        &self,
        f: &mut Formatter<'_>,
    ) -> std::fmt::Result {
        write!(
            f,
            "{}{}.{}",
            CatalystRBACTokenV1::AUTH_TOKEN_PREFIX,
            self.catalyst_id,
            BASE64_URL_SAFE_NO_PAD.encode(self.signature.to_bytes())
        )
    }
}

/// Converts the given token string to raw bytes.
fn as_raw_bytes(token: &str) -> Vec<u8> {
    // The signature is calculated over all bytes in the token including the final '.'.
    CatalystRBACTokenV1::AUTH_TOKEN_PREFIX
        .bytes()
        .chain(token.bytes())
        .chain(".".bytes())
        .collect()
}

/// Checks if the given network is supported.
fn convert_network((network, subnet): &(String, Option<String>)) -> Result<Network> {
    if network != "cardano" {
        return Err(anyhow!("Unsupported network: {network}"));
    }

    match subnet.as_deref() {
        None => Ok(Network::Mainnet),
        Some("preprod") => Ok(Network::Preprod),
        Some("preview") => Ok(Network::Preview),
        Some(subnet) => Err(anyhow!("Unsupported host: {subnet}.{network}",)),
    }
}

#[cfg(test)]
mod tests {

    use ed25519_dalek::SigningKey;
    use rand::rngs::OsRng;
    use test_case::test_case;

    use super::*;

    #[test_case("cardano", None ; "mainnet cardano network")]
    #[test_case("cardano", Some("preprod") ; "preprod.cardano network")]
    #[test_case("cardano", Some("preview") ; "preview.cardano network")]
    fn roundtrip(
        network: &'static str,
        subnet: Option<&'static str>,
    ) {
        let mut seed = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut seed);
        let verifying_key = signing_key.verifying_key();
        let token = CatalystRBACTokenV1::new(network, subnet, verifying_key, &signing_key).unwrap();
        assert_eq!(token.catalyst_id().username(), None);
        assert!(token.catalyst_id().nonce().is_some());
        assert_eq!(
            token.catalyst_id().network(),
            (network.to_string(), subnet.map(ToString::to_string))
        );
        assert!(!token.catalyst_id().is_encryption_key());
        assert!(token.catalyst_id().is_signature_key());

        let token_str = token.to_string();
        let parsed = CatalystRBACTokenV1::parse(&token_str).unwrap();
        assert_eq!(token.signature, parsed.signature);
        assert_eq!(token.raw, parsed.raw);
        assert_eq!(parsed.catalyst_id().username(), Some(String::new()));
        assert!(parsed.catalyst_id().nonce().is_some());
        assert_eq!(
            parsed.catalyst_id().network(),
            (network.to_string(), subnet.map(ToString::to_string))
        );
        assert!(!token.catalyst_id().is_encryption_key());
        assert!(token.catalyst_id().is_signature_key());

        let parsed_str = parsed.to_string();
        assert_eq!(token_str, parsed_str);
    }

    #[test]
    fn is_young() {
        let mut seed = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut seed);
        let verifying_key = signing_key.verifying_key();
        let mut token =
            CatalystRBACTokenV1::new("cardano", Some("preprod"), verifying_key, &signing_key)
                .unwrap();

        // Update the token timestamp to be two seconds in the past.
        let now = Utc::now();
        token.catalyst_id = token
            .catalyst_id
            .with_specific_nonce(now - Duration::from_secs(2));

        // Check that the token ISN'T young if max_age is one second.
        let max_age = Duration::from_secs(1);
        let max_skew = Duration::from_secs(1);
        assert!(!token.is_young(max_age, max_skew));

        // Check that the token IS young if max_age is three seconds.
        let max_age = Duration::from_secs(3);
        assert!(token.is_young(max_age, max_skew));

        // Update the token timestamp to be two seconds in the future.
        token.catalyst_id = token
            .catalyst_id
            .with_specific_nonce(now + Duration::from_secs(2));

        // Check that the token IS too new if max_skew is one seconds.
        let max_skew = Duration::from_secs(1);
        assert!(!token.is_young(max_age, max_skew));

        // Check that the token ISN'T too new if max_skew is three seconds.
        let max_skew = Duration::from_secs(3);
        assert!(token.is_young(max_age, max_skew));
    }
}
