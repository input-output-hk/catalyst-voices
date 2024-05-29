//! x509 Certificate library

use wasm_bindgen::prelude::*;
mod c509_cert;
mod c509_enum;
mod cbor_encoder;
mod extensions;

#[wasm_bindgen]
extern "C" {
    pub fn alert(s: &str);
}

#[wasm_bindgen]
/// Sample function for test only
pub fn greet(name: &str) {
    alert(&format!("Hello, {name}!"));
}
