//! Catalyst RBAC Token utility functions.

// cspell: words rsplit Fftx

use std::{
    fmt::{Display, Formatter},
    sync::Arc,
    time::Duration,
};

use anyhow::{anyhow, Context, Result};
use base64::{prelude::BASE64_URL_SAFE_NO_PAD, Engine};
use cardano_blockchain_types::Network;
use catalyst_types::id_uri::{key_rotation::KeyRotation, role_index::RoleIndex, IdUri};
use chrono::{TimeDelta, Utc};
use ed25519_dalek::{ed25519::signature::Signer, Signature, SigningKey, VerifyingKey};
use rbac_registration::registration::cardano::RegistrationChain;

use crate::db::index::{
    queries::rbac::get_rbac_registrations::build_reg_chain, session::CassandraSession,
};

/// A Catalyst RBAC Authorization Token.
///
/// See [this document] for more details.
///
/// [this document]: https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md
#[derive(Debug, Clone)]
pub(crate) struct CatalystRBACTokenV1 {
    /// A Catalyst identifier.
    catalyst_id: IdUri,
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
    /// TODO: make `RegistrationChain` clonable, remove Arc
    reg_chain: Option<Arc<RegistrationChain>>,
}

impl CatalystRBACTokenV1 {
    /// Bearer Token prefix for this token.
    const AUTH_TOKEN_PREFIX: &str = "catid.";

    /// Creates a new token instance.
    // TODO: Remove the attribute when the function is used.
    #[allow(dead_code)]
    pub(crate) fn new(
        network: &str, subnet: Option<&str>, role0_pk: VerifyingKey, sk: &SigningKey,
    ) -> Result<Self> {
        let catalyst_id = IdUri::new(network, subnet, role0_pk).with_nonce().as_id();
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

        let catalyst_id: IdUri = token.parse().context("Invalid Catalyst ID")?;
        if catalyst_id.username().is_some_and(|n| !n.is_empty()) {
            return Err(anyhow!("Catalyst ID must not contain username"));
        }
        if !catalyst_id.clone().is_id() {
            return Err(anyhow!("Catalyst ID must be in an ID format"));
        }
        if catalyst_id.nonce().is_none() {
            return Err(anyhow!("Catalyst ID must have nonce"));
        }
        let (role, rotation) = catalyst_id.role_and_rotation();
        if role != RoleIndex::DEFAULT {
            return Err(anyhow!("Catalyst ID mustn't have role specified"));
        }
        if rotation != KeyRotation::DEFAULT {
            return Err(anyhow!("Catalyst ID mustn't have rotation specified"));
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

    /// Given the `PublicKey`, verifies the token was correctly signed.
    pub(crate) fn verify(&self, public_key: &VerifyingKey) -> Result<()> {
        public_key
            .verify_strict(&self.raw, &self.signature)
            .context("Token signature verification failed")
    }

    /// Checks that the token timestamp is valid.
    ///
    /// The timestamp is valid if it isn't too old or too skewed.
    pub(crate) fn is_young(&self, max_age: Duration, max_skew: Duration) -> bool {
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
    pub(crate) fn catalyst_id(&self) -> &IdUri {
        &self.catalyst_id
    }

    /// Returns a network.
    pub(crate) fn network(&self) -> Network {
        self.network
    }

    /// Return a corresponded registration chain if any registrations present.
    /// If it is a first call, fetch all data from the db and initialize it.
    pub(crate) async fn get_reg_chain(&mut self) -> anyhow::Result<Option<&RegistrationChain>> {
        if self.reg_chain.is_none() {
            // TODO: properly handle failing acquiring db session, so the caller could handle this
            // case properly
            let session = CassandraSession::get(true)
                .ok_or(anyhow::anyhow!("Failed to acquire persistent db session"))?;
            let reg_chain = build_reg_chain(&session, self.catalyst_id(), self.network()).await?;
            self.reg_chain = reg_chain.map(Into::into);
        }

        Ok(self.reg_chain.as_ref().map(Arc::as_ref))
    }
}

impl Display for CatalystRBACTokenV1 {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
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
        Some("mainnet") => Ok(Network::Mainnet),
        Some("preprod") => Ok(Network::Preprod),
        Some("preview") => Ok(Network::Preview),
        _ => Err(anyhow!("Unsupported network: {network}")),
    }
}

#[cfg(test)]
mod tests {

    use ed25519_dalek::SigningKey;
    use rand::rngs::OsRng;

    use super::*;

    #[test]
    fn roundtrip() {
        let mut seed = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut seed);
        let verifying_key = signing_key.verifying_key();
        let token =
            CatalystRBACTokenV1::new("cardano", Some("preprod"), verifying_key, &signing_key)
                .unwrap();
        assert_eq!(token.catalyst_id().username(), None);
        assert!(token.catalyst_id().nonce().is_some());
        assert_eq!(
            token.catalyst_id().network(),
            ("cardano".into(), Some("preprod".into()))
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
            ("cardano".into(), Some("preprod".into()))
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

    #[test]
    fn verify() {
        let mut seed = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut seed);
        let verifying_key = signing_key.verifying_key();
        let token =
            CatalystRBACTokenV1::new("cardano", Some("preprod"), verifying_key, &signing_key)
                .unwrap();
        token.verify(&verifying_key).unwrap();
    }
}
