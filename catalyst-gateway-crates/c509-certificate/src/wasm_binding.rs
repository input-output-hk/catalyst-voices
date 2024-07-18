//! WASM binding for the C509 certificate crate.

use minicbor::{Encode, Encoder};
use wasm_bindgen::{prelude::wasm_bindgen, JsValue};

use crate::{c509_big_uint::UnwrappedBigUint, tbs_cert::TbsCert};

/// Generate
#[wasm_bindgen]
pub fn generate(tbs_cert: JsValue, _private_key: JsValue) -> Result<JsValue, JsValue> {
    let x: TbsCert = serde_wasm_bindgen::from_value(tbs_cert)?;
    return Ok(serde_wasm_bindgen::to_value(&x)?);
}

/// Test
#[wasm_bindgen]
pub fn test(x: UnwrappedBigUint) -> Result<JsValue, JsValue> {
    let mut buffer = Vec::new();
    let mut encoder = Encoder::new(&mut buffer);
    x.encode(&mut encoder, &mut ())
        .map_err(|e| JsValue::from(e.to_string()))?;
    Ok(serde_wasm_bindgen::to_value(&buffer)?)
}

/// Test2
#[wasm_bindgen]
pub fn test2(x: JsValue) -> Result<JsValue, JsValue> {
    let mut buffer = Vec::new();
    let mut encoder = Encoder::new(&mut buffer);
    let y: TbsCert = serde_wasm_bindgen::from_value(x)?;
    y.encode(&mut encoder, &mut ())
        .map_err(|e| JsValue::from(e.to_string()))?;
    Ok(serde_wasm_bindgen::to_value(&buffer)?)
}
