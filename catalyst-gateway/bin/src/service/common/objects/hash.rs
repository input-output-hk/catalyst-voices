use poem_openapi::{types::Example, Object};

#[derive(Object)]
#[oai(example = true)]
/// Blake2b256 hash wrapper.
pub(crate) struct Hash {
    /// Blake2b256 hash encoded in hex.
    pub hash: String,
}

impl Example for Hash {
    fn example() -> Self {
        Self {
            hash: "928b20366943e2afd11ebc0eae2e53a93bf177a4fcf35bcc64d503704e65e202".to_string(),
        }
    }
}
