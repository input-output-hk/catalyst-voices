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
#[allow(dead_code)]
pub struct SignatureEd25519([u8; 64]);

/// The Encoded Binary Auth Token is a [CBOR sequence] that consists of 3 fields.
/// A CBOR Sequence consists of any number of encoded CBOR data items, simply concatenated
/// in sequence. `kid` : The key identifier - 16 bytes .
/// `ulid` : A ULID which defines when the token was issued, and a random nonce - 16
/// bytes. `signature` : The signature over the `kid` and `ulid` fields - 64 bytes.
/// kid + ulid + sig = 96 bytes
#[allow(dead_code)]
pub fn encode_auth_token_ed25519(
    kid: Kid, ulid: UlidBytes, secret_key_bytes: [u8; SECRET_KEY_LENGTH],
) -> anyhow::Result<String> {
    const AUTH_TOKEN_PREFIX: &str = "catv1";

    let sk: SigningKey = SigningKey::from_bytes(&secret_key_bytes);

    let signature: [u8; SIGNATURE_LENGTH] = sk.sign(&[kid.0, ulid.0].concat()).to_bytes();

    let out: Vec<u8> = Vec::new();
    let mut encoder = minicbor::Encoder::new(out);

    encoder.bytes(&kid.0)?;
    encoder.bytes(&ulid.0)?;
    encoder.bytes(&signature)?;

    Ok(format!(
        "{}.{}",
        AUTH_TOKEN_PREFIX,
        BASE64_STANDARD.encode(&encoder.writer())
    ))
}

/// Decode base64 auth token into constituent parts of (kid, ulid, signature)
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
        ed25519::signature::SignerMut, Signature, SigningKey, VerifyingKey, SECRET_KEY_LENGTH,
    };
    use rand::rngs::OsRng;

    use super::{encode_auth_token_ed25519, Kid, UlidBytes};
    use crate::service::api::auth::decode_auth_token_ed25519;
    use ed25519_dalek::Verifier;

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

        let (decoded_kid, decoded_ulid, decoded_sig) =
            decode_auth_token_ed25519(auth_token).unwrap();

        assert_eq!(decoded_kid.0, kid);
        assert_eq!(decoded_ulid.0, ulid);

        let sig = Signature::from_bytes(&decoded_sig.0);

        println!("signature {:?}", hex::encode(sig.to_vec()));

        let verifiying_key =
            VerifyingKey::from_bytes(&signing_key.verifying_key().as_bytes()).unwrap();

        let message = &[decoded_kid.0, decoded_ulid.0].concat();

        verifiying_key.verify(message, &sig).unwrap();
    }

    #[test]
    fn test_token_decode() {
        // tokens generated from frontend
        let auth_token="catv1.UARn3mvZRbkge/oJ2Ea3fvVQAADErjOAvTBnWVpkevVkXFhAbZzcNJv+wrcRQcHJoYzdbjQARHAfijprYapZ/X1u+B5fLHqhZfHafFr3YJc2WHOodorZc56vPK02YXiKisicAw==";
        let (kid, ulid, _sig) = decode_auth_token_ed25519(auth_token.to_owned()).unwrap();

        // preceding token generated from the following kid + ulid
        let kid_frontend: [u8; 16] = hex::decode("0467de6bd945b9207bfa09d846b77ef5".to_string())
            .unwrap()
            .try_into()
            .unwrap();

        assert_eq!(kid.0, kid_frontend);

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

        let mut sk = SigningKey::from_bytes(&sk);

        println!("{:?}", pub_key.len());

        let verifiying_key = VerifyingKey::from_bytes(&pub_key).unwrap();

        let message = &[kid.0, ulid.0].concat();

        let signed = sk.sign(message);

        verifiying_key.verify(message, &signed).unwrap();
    }
}
