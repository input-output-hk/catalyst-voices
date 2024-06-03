//! x509 Certificate library

use c509_cert::TbsCertificate;
use wasm_bindgen::prelude::wasm_bindgen;
mod c509_cert;
mod c509_enum;
mod cbor_encoder;
mod extensions;

#[wasm_bindgen]
/// Sample function for test only
pub fn generate_c509_cert(tbs_cert: TbsCertificate) -> Vec<u8> {
    c509_cert::generate_c509_cert(tbs_cert)
}
