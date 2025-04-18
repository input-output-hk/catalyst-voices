//! Types of Blake-2b Hash

use blake2b_simd::Params;

/// Generates a UUID string from the provided key and data using `BLAKE2b` hashing.
///
/// # Arguments
/// - `key`: A string slice that is used as part of the hash function input.
/// - `data`: A vector of strings which will be included in the `BLAKE2b` hash
///   computation.
///
/// # Returns
/// A UUID string generated from the `BLAKE2b` hash of the concatenated data with the key.
pub(crate) fn generate_uuid_string_from_data(key: &str, data: &[String]) -> String {
    // Where we will actually store the bytes we derive the UUID from.
    let mut bytes: uuid::Bytes = uuid::Bytes::default();

    // Generate a unique hash of the data.
    let mut hasher = Params::new()
        .hash_length(bytes.len())
        .key(key.as_bytes())
        .personal(b"Project Catalyst")
        .to_state();

    for datum in data {
        hasher.update(datum.as_bytes());
    }

    // Finalize the hash and get the digest as a byte array
    let hash = hasher.finalize();

    // Create a new array containing the first 16 elements from the original array
    bytes.copy_from_slice(hash.as_bytes());

    // Convert the hash to a UUID
    uuid::Builder::from_custom_bytes(bytes)
        .as_uuid()
        .as_hyphenated()
        .to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_uuid_string_from_data() {
        let key = "test key";
        let data = vec!["test1".to_string(), "test2".to_string()];

        // Call the function under test
        let uuid_str = generate_uuid_string_from_data(key, &data);

        // Verify that the output is a valid UUID string
        assert!(uuid::Uuid::parse_str(&uuid_str).is_ok());
    }

    #[test]
    fn test_generate_uuid_string_from_data_empty_data() {
        let key = "test key";
        let data: Vec<String> = vec![];

        // Call the function under test
        let uuid_str = generate_uuid_string_from_data(key, &data);

        // Verify that the output is a valid UUID string
        assert!(uuid::Uuid::parse_str(&uuid_str).is_ok());
    }

    #[test]
    fn test_generate_uuid_string_from_data_empty_key() {
        let key = "";
        let data = vec!["test1".to_string(), "test2".to_string()];

        // Call the function under test
        let uuid_str = generate_uuid_string_from_data(key, &data);

        // Verify that the output is a valid UUID string
        assert!(uuid::Uuid::parse_str(&uuid_str).is_ok());
    }
}
