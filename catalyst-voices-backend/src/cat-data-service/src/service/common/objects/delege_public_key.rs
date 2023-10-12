//! Define the Public Key used by a Delegate.
//!
use poem_openapi::{types::Example, Object};

#[derive(Object)]
#[oai(example = true)]
pub(crate) struct DelegePublicKey {
    #[oai(validator(pattern = "0x[0-9a-f]{64}"))]
    address: String,
}

impl From<String> for DelegePublicKey {
    fn from(address: String) -> Self {
        Self { address }
    }
}

impl Example for DelegePublicKey {
    fn example() -> Self {
        Self {
            address: "0xad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee"
                .to_string(),
        }
    }
}
