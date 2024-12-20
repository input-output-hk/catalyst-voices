//! Catalyst RBAC Token utility functions.
use std::{
    fmt::{Display, Formatter},
    time::{Duration, SystemTime},
};

use anyhow::{bail, Ok};
use base64::{prelude::BASE64_URL_SAFE_NO_PAD, Engine};
use ed25519_dalek::{ed25519::signature::Signer, Signature, SigningKey, VerifyingKey};
use minicbor::{Decode, Encode};
use tracing::error;
use ulid::Ulid;

use super::role0_kid::Role0Kid;

/// Identifier for this token, encodes both the time the token was issued and a random
/// nonce.
#[derive(Debug, Clone, Copy)]
struct UlidBytes(pub [u8; 16]);

/// Ed25519 signatures are (64 bytes)
#[derive(Debug, Clone)]
pub struct SignatureEd25519(pub [u8; 64]);

/// A Catalyst RBAC Authorization Token.
#[derive(Debug, Clone)]
pub(crate) struct CatalystRBACTokenV1 {
    /// Token Key Identifier
    pub(crate) kid: Role0Kid,
    /// Tokens ULID (Time and Random Nonce)
    pub(crate) ulid: Ulid,
    /// Ed25519 Signature of the Token
    pub(crate) sig: SignatureEd25519,
    /// Raw bytes of the token
    raw: Vec<u8>,
}

impl CatalystRBACTokenV1 {
    /// Bearer Token prefix for this token.
    const AUTH_TOKEN_PREFIX: &str = "catv1";
    /// The message is a Cbor sequence (cbor(kid) + cbor(ulid)):
    /// kid + ulid are 16 bytes a piece, with 1 byte extra due to cbor encoding,
    /// The two fields include their encoding resulting in 17 bytes each.
    const KID_ULID_CBOR_ENCODED_BYTES: u8 = 34;

    /// The Encoded Binary Auth Token is a [CBOR sequence] that consists of 3 fields [
    /// kid, ulid, signature ]. ED25519 Signature over the preceding two fields -
    /// sig(cbor(kid), cbor(ulid))
    #[allow(dead_code, clippy::expect_used)]
    pub(crate) fn new(sk: &SigningKey, der_cert: &Vec<u8>) -> Self {
        // Generate the Kid from the der_certificate
        let kid = Role0Kid::new(der_cert);

        // Create a enw ulid for this token.
        let ulid = Ulid::new();

        let out: Vec<u8> = Vec::new();
        let mut encoder = minicbor::Encoder::new(out);

        // It is safe to use expect here, because the calls are infallible
        kid.encode(&mut encoder, &mut ())
            .expect("This should never fail.");
        encoder
            .bytes(&ulid.to_bytes())
            .expect("This should never fail");

        let sig = SignatureEd25519(sk.sign(encoder.writer()).to_bytes());

        encoder.bytes(&sig.0).expect("This should never fail");

        Self {
            kid,
            ulid,
            sig,
            raw: encoder.writer().clone(),
        }
    }

    /// Decode base64 cbor encoded auth token into constituent parts of (kid, ulid,
    /// signature)
    /// e.g catv1.UAARIjNEVWZ3iJmqu8zd7v9QAZEs7HHPLEwUpV1VhdlNe1hAAAAAAAAAAAAA...
    pub(crate) fn decode(auth_token: &str) -> anyhow::Result<Self> {
        let token = auth_token.split('.').collect::<Vec<&str>>();

        let prefix = token.first().ok_or(anyhow::anyhow!("No valid prefix"))?;
        if *prefix != Self::AUTH_TOKEN_PREFIX {
            return Err(anyhow::anyhow!("Corrupt token, invalid prefix"));
        }
        let token_base64 = token.get(1).ok_or(anyhow::anyhow!("No valid token"))?;
        let token_cbor_encoded = BASE64_URL_SAFE_NO_PAD.decode(token_base64)?;

        // Decode cbor to bytes
        let mut cbor_decoder = minicbor::Decoder::new(&token_cbor_encoded);

        // Raw kid bytes
        let kid = Role0Kid::decode(&mut cbor_decoder, &mut ())?;

        // TODO: Check what happens if the ULID is NOT 28 bytes long
        let ulid_raw: UlidBytes = UlidBytes(
            cbor_decoder
                .bytes()
                .map_err(|e| anyhow::anyhow!(format!("Invalid cbor for ulid : {e}")))?
                .try_into()?,
        );
        let ulid = Ulid::from_bytes(ulid_raw.0);

        // Raw signature
        let signature = SignatureEd25519(
            cbor_decoder
                .bytes()
                .map_err(|e| anyhow::anyhow!(format!("Invalid cbor for signature : {e}")))?
                .try_into()?,
        );

        Ok(CatalystRBACTokenV1 {
            kid,
            ulid,
            sig: signature,
            raw: token_cbor_encoded,
        })
    }

    /// Given the `PublicKey`, verify the token was correctly signed.
    pub(crate) fn verify(&self, public_key: &VerifyingKey) -> anyhow::Result<()> {
        // TODO: KID is the hash of the cert, not the key.
        // Verify the Kid of the Token matches the PublicKey.
        //if self.kid != *public_key {
        //    error!(token=%self, public_key=?public_key,
        //        "Tokens Kid did not match verifying Public Key",
        //    );
        //    bail!("Kid does not match PublicKey.")
        //}

        // We verify the signature on the message which corresponds to a Cbor sequence (cbor(kid)
        // + cbor(ulid)):
        let message_cbor_encoded = self
            .raw
            .get(0..Self::KID_ULID_CBOR_ENCODED_BYTES.into())
            .ok_or(anyhow::anyhow!("No valid token"))?;

        if let Err(error) =
            public_key.verify_strict(message_cbor_encoded, &Signature::from_bytes(&self.sig.0))
        {
            error!(error=%error, token=%self, public_key=?public_key,
                "Token was not signed by the expected Public Key",
            );
            bail!("Token Not Validated");
        }

        Ok(())
    }

    /// Check if the token is young enough.
    /// Old tokens are no longer valid.
    pub(crate) fn is_young(&self, max_age: Duration, max_skew: Duration) -> bool {
        // We check that the token is not too old or too skewed.
        let now = SystemTime::now();
        let token_age = self.ulid.datetime();

        // The token is considered old if it was issued more than max_age ago.
        // And newer than an allowed clock skew value
        // This is a safety measure to avoid replay attacks.
        ((now - max_age) < token_age) && ((now + max_skew) > token_age)
    }
}

impl Display for CatalystRBACTokenV1 {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}.{}",
            CatalystRBACTokenV1::AUTH_TOKEN_PREFIX,
            BASE64_URL_SAFE_NO_PAD.encode(self.raw.clone())
        )
    }
}

#[cfg(test)]
mod tests {

    use std::str::FromStr;

    use ed25519_dalek::SigningKey;
    use rand::rngs::OsRng;

    use super::*;

    #[test]
    fn test_token_generation_and_decoding() {
        let mut random_seed = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut random_seed);
        let verifying_key = signing_key.verifying_key();

        let _serial_number = x509_cert::serial_number::SerialNumber::from(42u32);
        let _validity = x509_cert::time::Validity::from_now(Duration::new(5, 0)).unwrap();
        let _profile = x509_cert::builder::Profile::Root;
        let _subject =
            x509_cert::name::Name::from_str("CN=Project Catalyst,O=Project Catalyst,C=SG").unwrap();

        let _pub_key = x509_cert::spki::SubjectPublicKeyInfoOwned::from_key(verifying_key)
            .expect("get ed25519 pub key");

        /* The following is broken, needs fixing by encoding an X509 certificate from the generated keys, and using that.

        let mut builder = x509_cert::builder::CertificateBuilder::new(
            profile,
            serial_number,
            validity,
            subject,
            pub_key,
            &signing_key,
        )
        .expect("Create certificate");

        //let signing_key2: SigningKey = SigningKey::generate(&mut random_seed);
        //let verifying_key2 = signing_key2.verifying_key();

        // Generate a Kid and then check it verifies properly against itself.
        // And doesn't against a different verifying key.
        //let kid = Kid::from(&verifying_key);
        //assert!(kid == verifying_key);
        //assert!(kid != verifying_key2);

        // Create a new Catalyst V1 Token
        //let token = CatalystRBACTokenV1::new(&signing_key);
        // Check its signed properly against its own key, and not another.
        //assert!(token.verify(&verifying_key).is_ok());
        //assert!(token.verify(&verifying_key2).is_err());

        //let decoded_token = format!("{token}");

        //let re_encoded_token = CatalystRBACTokenV1::decode(&decoded_token)
        //    .expect("Failed to decode a token we encoded.");

        // Check its still signed properly against its own key, and not another.
        //assert!(re_encoded_token.verify(&verifying_key).is_ok());
        //assert!(re_encoded_token.verify(&verifying_key2).is_err());
        */
    }

    /* Test also broken because its using a public key as the src for the kid, not the cert.
    #[test]
    fn is_young() {
        let mut random_seed = OsRng;
        let key = SigningKey::generate(&mut random_seed);
        let mut token = CatalystRBACTokenV1::new(&key);

        // Update the token timestamp to be two seconds in the past.
        let now = SystemTime::now();
        token.ulid = Ulid::from_datetime(now - Duration::from_secs(2));

        // Check that the token ISN'T young if max_age is one second.
        let max_age = Duration::from_secs(1);
        let max_skew = Duration::from_secs(1);
        assert!(!token.is_young(max_age, max_skew));

        // Check that the token IS young if max_age is three seconds.
        let max_age = Duration::from_secs(3);
        assert!(token.is_young(max_age, max_skew));

        // Update the token timestamp to be two seconds in the future.
        token.ulid = Ulid::from_datetime(now + Duration::from_secs(2));

        // Check that the token IS too new if max_skew is one seconds.
        let max_skew = Duration::from_secs(1);
        assert!(!token.is_young(max_age, max_skew));

        // Check that the token ISN'T too new if max_skew is three seconds.
        let max_skew = Duration::from_secs(3);
        assert!(token.is_young(max_age, max_skew));
    }
     */
}
