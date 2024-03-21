//! Define the Stake Public Key type
use poem_openapi::{types::Example, NewType};
use serde::Deserialize;

#[derive(NewType, Deserialize)]
#[oai(example = true)]
/// Stake Public Key
pub(crate) struct StakePublicKey(pub(crate) String);

impl Example for StakePublicKey {
    fn example() -> Self {
        Self("0xad4b948699193634a39dd56f779a2951a24779ad52aa7916f6912b8ec4702cee".into())
    }
}
