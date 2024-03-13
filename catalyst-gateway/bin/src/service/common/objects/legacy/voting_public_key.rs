//! Define the Voters Public Key
use poem_openapi::{types::Example, NewType};
use serde::Deserialize;

#[derive(NewType, Deserialize)]
#[oai(example = true)]
/// Voting Public Key
pub(crate) struct VotingPublicKey(pub(crate) String);

impl Example for VotingPublicKey {
    fn example() -> Self {
        Self("0xa6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".into())
    }
}
