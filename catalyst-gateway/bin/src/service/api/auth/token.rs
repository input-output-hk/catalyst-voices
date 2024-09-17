use anyhow::Ok;
use base64::{prelude::BASE64_STANDARD, Engine};
use ed25519_dalek::{Signer, SigningKey, SECRET_KEY_LENGTH, SIGNATURE_LENGTH};
use pallas::codec::minicbor;

/// Key ID - Blake2b-128 hash of the Role 0 Certificate defining the Session public key.
/// BLAKE2b-128 produces digest side of 16 bytes.
#[derive(Debug, Clone, Copy)]
pub struct Kid(pub [u8; 16]);

/// Identifier for this token, encodes both the time the token was issued and a random
/// nonce.
#[derive(Debug, Clone, Copy)]
pub struct UlidBytes(pub [u8; 16]);

/// Ed25519 signatures are (64 bytes)
#[derive(Debug, Clone)]
pub struct SignatureEd25519(pub [u8; 64]);

/// The Encoded Binary Auth Token is a [CBOR sequence] that consists of 3 fields [ kid,
/// ulid, signature ]. ED25519 Signature over the preceding two fields - sig(cbor(kid),
/// cbor(ulid))
#[allow(dead_code)]
pub fn encode_auth_token_ed25519(
    kid: &Kid, ulid: &UlidBytes, secret_key_bytes: [u8; SECRET_KEY_LENGTH],
) -> anyhow::Result<String> {
    /// Auth token prefix as per spec
    const AUTH_TOKEN_PREFIX: &str = "catv1";

    let sk: SigningKey = SigningKey::from_bytes(&secret_key_bytes);

    let out: Vec<u8> = Vec::new();
    let mut encoder = minicbor::Encoder::new(out);

    encoder.bytes(&kid.0)?;
    encoder.bytes(&ulid.0)?;

    let signature: [u8; SIGNATURE_LENGTH] = sk.sign(encoder.writer()).to_bytes();

    encoder.bytes(&signature)?;

    Ok(format!(
        "{}.{}",
        AUTH_TOKEN_PREFIX,
        BASE64_STANDARD.encode(encoder.writer())
    ))
}

/// Decode base64 cbor encoded auth token into constituent parts of (kid, ulid, signature)
/// e.g catv1.UAARIjNEVWZ3iJmqu8zd7v9QAZEs7HHPLEwUpV1VhdlNe1hAAAAAAAAAAAAA...
#[allow(dead_code)]
pub fn decode_auth_token_ed25519(
    auth_token: &str,
) -> anyhow::Result<(Kid, UlidBytes, SignatureEd25519, Vec<u8>)> {
    /// The message is a Cbor sequence (cbor(kid) + cbor(ulid)):
    /// kid + ulid are 16 bytes a piece, with 1 byte extra due to cbor encoding,
    /// The two fields include their encoding resulting in 17 bytes each.
    const KID_ULID_CBOR_ENCODED_BYTES: u8 = 34;
    /// Auth token prefix
    const AUTH_TOKEN_PREFIX: &str = "catv1";

    let token = auth_token.split('.').collect::<Vec<&str>>();

    let prefix = token.first().ok_or(anyhow::anyhow!("No valid prefix"))?;
    if *prefix != AUTH_TOKEN_PREFIX {
        return Err(anyhow::anyhow!("Corrupt token, invalid prefix"));
    }
    let token_base64 = token.get(1).ok_or(anyhow::anyhow!("No valid token"))?;
    let token_cbor_encoded = BASE64_STANDARD.decode(token_base64)?;

    // We verify the signature on the message which corresponds to a Cbor sequence (cbor(kid)
    // + cbor(ulid)):
    let message_cbor_encoded = &token_cbor_encoded
        .get(0..KID_ULID_CBOR_ENCODED_BYTES.into())
        .ok_or(anyhow::anyhow!("No valid token"))?;

    // Decode cbor to bytes
    let mut cbor_decoder = minicbor::Decoder::new(&token_cbor_encoded);

    // Raw kid bytes
    let kid = Kid(cbor_decoder
        .bytes()
        .map_err(|e| anyhow::anyhow!(format!("Invalid cbor for kid : {e}")))?
        .try_into()?);

    // Raw ulid bytes
    let ulid = UlidBytes(
        cbor_decoder
            .bytes()
            .map_err(|e| anyhow::anyhow!(format!("Invalid cbor for ulid : {e}")))?
            .try_into()?,
    );

    // Raw signature
    let signature = SignatureEd25519(
        cbor_decoder
            .bytes()
            .map_err(|e| anyhow::anyhow!(format!("Invalid cbor for sig : {e}")))?
            .try_into()?,
    );

    Ok((kid, ulid, signature, message_cbor_encoded.to_vec()))
}

#[cfg(test)]
mod tests {

    use ed25519_dalek::{Signature, SigningKey, Verifier, SECRET_KEY_LENGTH};
    use rand::rngs::OsRng;

    use super::{encode_auth_token_ed25519, Kid, UlidBytes};
    use crate::service::api::auth::token::decode_auth_token_ed25519;

    #[test]
    fn test_token_generation_and_decoding() {
        let kid: [u8; 16] = hex::decode("00112233445566778899aabbccddeeff")
            .unwrap()
            .try_into()
            .unwrap();
        let ulid: [u8; 16] = hex::decode("01912cec71cf2c4c14a55d5585d94d7b")
            .unwrap()
            .try_into()
            .unwrap();

        let mut random_seed = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut random_seed);

        let verifying_key = signing_key.verifying_key();

        let secret_key_bytes: [u8; SECRET_KEY_LENGTH] = *signing_key.as_bytes();

        let auth_token =
            encode_auth_token_ed25519(&Kid(kid), &UlidBytes(ulid), secret_key_bytes).unwrap();

        let (decoded_kid, decoded_ulid, decoded_sig, message) =
            decode_auth_token_ed25519(&auth_token).unwrap();

        assert_eq!(decoded_kid.0, kid);
        assert_eq!(decoded_ulid.0, ulid);

        verifying_key
            .verify(&message, &Signature::from(&decoded_sig.0))
            .unwrap();
    }
}
