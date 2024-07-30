//! WASM binding wrapper for the C509 certificate crate.

use std::str::FromStr;

use minicbor::Decode;
use wasm_bindgen::{prelude::wasm_bindgen, JsValue};

use crate::{
    signing::{PrivateKey, PublicKey},
    tbs_cert::TbsCert,
};

/// Wrapper for generate function.
///
/// # Errors
/// Returns an error if the provided TbsCert JSValue cannot be converted `TbsCert` or C509
/// cannot be generated.
#[wasm_bindgen]
// wasm_bindgen does not allowed ref passing unless it implement `RefFromWasmAbi`.
#[allow(clippy::needless_pass_by_value)]
pub fn generate(tbs_cert: JsValue, private_key: Option<PrivateKey>) -> Result<JsValue, JsValue> {
    let tbs_cert: TbsCert = serde_wasm_bindgen::from_value(tbs_cert)?;
    let c509 = crate::generate(&tbs_cert, private_key.as_ref())
        .map_err(|e| JsValue::from(e.to_string()))?;
    Ok(serde_wasm_bindgen::to_value(&c509)?)
}

/// Wrapper for verify function.
///
/// # Errors
/// Returns an error if the signature is invalid or the signature cannot be verified.
#[wasm_bindgen]
pub fn verify(c509: &[u8], public_key: &PublicKey) -> Result<JsValue, JsValue> {
    match crate::verify(c509, public_key) {
        Ok(()) => Ok(JsValue::from("Signature verified")),
        Err(e) => Err(JsValue::from(e.to_string())),
    }
}

/// Wrapper for decoding vector of C509 back to readable object.
///
/// # Errors
/// Returns an error if the provided vector is not a valid C509 certificate.
#[wasm_bindgen]
pub fn decode(c509: &[u8]) -> Result<JsValue, JsValue> {
    let mut d = minicbor::Decoder::new(c509);
    let c509 = crate::C509::decode(&mut d, &mut ()).map_err(|e| JsValue::from(e.to_string()))?;
    Ok(serde_wasm_bindgen::to_value(&c509)?)
}

#[wasm_bindgen]
impl PrivateKey {
    /// Convert string to private key.
    ///
    /// # Errors
    /// Returns an error if the provided string is not a valid private key.
    #[wasm_bindgen]
    pub fn str_to_sk(str: &str) -> Result<PrivateKey, JsValue> {
        FromStr::from_str(str).map_err(|_| {
            JsValue::from("Cannot decode private key from string. Invalid PEM format.")
        })
    }
}

#[wasm_bindgen]
impl PublicKey {
    /// Convert string to public key.
    ///
    /// # Errors
    /// Returns an error if the provided string is not a valid public key.
    #[wasm_bindgen]
    pub fn str_to_pk(str: &str) -> Result<PublicKey, JsValue> {
        FromStr::from_str(str)
            .map_err(|_| JsValue::from("Cannot decode public key from string. Invalid PEM format."))
    }
}
