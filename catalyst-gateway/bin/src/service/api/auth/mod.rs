use anyhow::Ok;
use base64::{prelude::BASE64_STANDARD, Engine};
use ed25519_dalek::{Signer, SigningKey, SECRET_KEY_LENGTH, SIGNATURE_LENGTH};
use pallas::codec::minicbor;

/// Key ID - Blake2b-128 hash of the Role 0 Certificate defining the Session public key.
/// BLAKE2b-128 produces digest side of 16 bytes.
#[derive(Debug)]
pub struct Kid([u8; 16]);

/// Identifier for this token, encodes both the time the token was issued and a random
/// nonce.
#[derive(Debug)]
pub struct UlidBytes([u8; 16]);

// Ed25519 signatures are (64 bytes)
// The signature over the cbor encoded `kid` and `ulid` fields.
#[allow(dead_code)]
pub struct SignatureEd25519([u8; 64]);

/// The Encoded Binary Auth Token is a [CBOR sequence] that consists of 3 fields [ kid,
/// ulid, signature ]. ED25519 Signature over the preceding two fields - sig(cbor(kid),
/// cbor(ulid))
#[allow(dead_code)]
pub fn encode_auth_token_ed25519(
    kid: Kid, ulid: UlidBytes, secret_key_bytes: [u8; SECRET_KEY_LENGTH],
) -> anyhow::Result<String> {
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
        BASE64_STANDARD.encode(&encoder.writer())
    ))
}

/// Decode base64 cbor encoded auth token into constituent parts of (kid, ulid, signature)
/// e.g catv1.UAARIjNEVWZ3iJmqu8zd7v9QAZEs7HHPLEwUpV1VhdlNe1hAAAAAAAAAAAAA...
#[allow(dead_code)]
pub fn decode_auth_token_ed25519(
    auth_token: String,
) -> anyhow::Result<(Kid, UlidBytes, SignatureEd25519)> {
    const AUTH_TOKEN_PREFIX: &str = "catv1";

    let token = auth_token.split(".").collect::<Vec<&str>>();

    let prefix = token.get(0).ok_or(anyhow::anyhow!("No valid prefix"))?;
    if *prefix != AUTH_TOKEN_PREFIX {
        return Err(anyhow::anyhow!("Corrupt token, invalid prefix"));
    } else {
        let token_base64 = token.get(1).ok_or(anyhow::anyhow!("No valid token"))?;
        let decoded_token = BASE64_STANDARD.decode(token_base64)?;

        let mut cbor_decoder = minicbor::Decoder::new(&decoded_token);

        let kid = Kid(cbor_decoder
            .bytes()
            .map_err(|e| anyhow::anyhow!(format!("invalid cbor for kid : {e}")))?
            .try_into()?);

        let ulid = UlidBytes(
            cbor_decoder
                .bytes()
                .map_err(|e| anyhow::anyhow!(format!("invalid cbor for ulid : {e}")))?
                .try_into()?,
        );

        let signature = SignatureEd25519(
            cbor_decoder
                .bytes()
                .map_err(|e| anyhow::anyhow!(format!("invalid cbor for sig : {e}")))?
                .try_into()?,
        );

        Ok((kid, ulid, signature))
    }
}

#[cfg(test)]
mod tests {

    use ed25519_dalek::{
        ed25519::signature::SignerMut, Signature, SigningKey, Verifier, VerifyingKey,
        SECRET_KEY_LENGTH,
    };
    use rand::rngs::OsRng;

    use super::{encode_auth_token_ed25519, Kid, UlidBytes};
    use crate::service::api::auth::decode_auth_token_ed25519;

    #[test]
    fn test_token_generation() {
        let kid: [u8; 16] = hex::decode("00112233445566778899aabbccddeeff".to_string())
            .unwrap()
            .try_into()
            .unwrap();
        let ulid: [u8; 16] = hex::decode("01912cec71cf2c4c14a55d5585d94d7b".to_string())
            .unwrap()
            .try_into()
            .unwrap();

        let mut csprng = OsRng;
        let signing_key: SigningKey = SigningKey::generate(&mut csprng);

        let secret_key_bytes: [u8; SECRET_KEY_LENGTH] = *signing_key.as_bytes();

        let auth_token =
            encode_auth_token_ed25519(Kid(kid), UlidBytes(ulid), secret_key_bytes).unwrap();

        let (decoded_kid, decoded_ulid, _decoded_sig) =
            decode_auth_token_ed25519(auth_token).unwrap();

        assert_eq!(decoded_kid.0, kid);
        assert_eq!(decoded_ulid.0, ulid);
    }

    #[test]
    fn test_token_decode() {
        // tokens generated from frontend
        let auth_token="catv1.UARn3mvZRbkge/oJ2Ea3fvVQAADErjOAgmcKUOev4sQfNVhAtCaGjDyDarc9AMqeiAUlVrPdSu+VGnX4Lf+648bwRoUpjBj7j4VrK6B8np/KyG6jTRwzUTj+7u29fFlmrunMBg==";
        let (kid, ulid, sig) = decode_auth_token_ed25519(auth_token.to_owned()).unwrap();

        assert_eq!(hex::encode(kid.0), "0467de6bd945b9207bfa09d846b77ef5");
        assert_eq!(hex::encode(ulid.0), "0000c4ae338082670a50e7afe2c41f35");

        let sk: [u8; 32] =
            hex::decode("fd622372c5ee1f3dc98e90666843a786391664d0e286ac6f3da51226aaa93cd5")
                .unwrap()
                .try_into()
                .unwrap();

        let pub_key: [u8; 32] =
            hex::decode("b45b8295e2701d2dbc8d4093fae94b979735f8c5e17a1843cf64a298e86659a2")
                .unwrap()
                .try_into()
                .unwrap();

        let signature: Signature = Signature::from_bytes(&sig.0);

        assert_eq!(hex::encode(signature.to_bytes()),"b426868c3c836ab73d00ca9e88052556b3dd4aef951a75f82dffbae3c6f04685298c18fb8f856b2ba07c9e9fcac86ea34d1c335138feeeedbd7c5966aee9cc06".to_string());

        let message =
            hex::decode("500467de6bd945b9207bfa09d846b77ef5500000c4ae338082670a50e7afe2c41f35")
                .unwrap();

        let mut sk = SigningKey::from_bytes(&sk);
        let signed = sk.sign(&message);

        let verifiying_key = VerifyingKey::from_bytes(&pub_key).unwrap();

        verifiying_key.verify(&message, &signed).unwrap();
    }
}
