//! x509 Certificate library

use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    pub fn alert(s: &str);
}

#[wasm_bindgen]
/// Sample function for test only
pub fn greet(name: &str) {
    alert(&format!("Hello, {}!", name));
}
