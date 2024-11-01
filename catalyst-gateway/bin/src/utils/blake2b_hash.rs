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

/// 224 Byte Blake2b Hash
pub(crate) type Blake2b224 = [u8; 28];

/// Computes a BLAKE2b-224 hash of the input bytes.
///
/// # Arguments
/// - `input_bytes`: A slice of bytes to be hashed.
///
/// # Returns
/// An array containing the BLAKE2b-224 hash of the input bytes.
pub(crate) fn blake2b_224(input_bytes: &[u8]) -> Blake2b224 {
    // Where we will actually store the bytes we derive the UUID from.
    let mut bytes: Blake2b224 = Blake2b224::default();

    // Generate a unique hash of the data.
    let mut hasher = Params::new().hash_length(bytes.len()).to_state();

    hasher.update(input_bytes);
    let hash = hasher.finalize();

    // Create a new array containing the first 16 elements from the original array
    bytes.copy_from_slice(hash.as_bytes());

    bytes
}

/// 256 Byte Blake2b Hash
pub(crate) type Blake2b256 = [u8; 32];

/// Computes a BLAKE2b-256 hash of the input bytes.
///
/// # Arguments
/// - `input_bytes`: A slice of bytes to be hashed.
///
/// # Returns
/// An array containing the BLAKE2b-256 hash of the input bytes.
#[allow(dead_code)]
pub(crate) fn blake2b_256(input_bytes: &[u8]) -> Blake2b256 {
    // Where we will actually store the bytes we derive the UUID from.
    let mut bytes: Blake2b256 = Blake2b256::default();

    // Generate a unique hash of the data.
    let mut hasher = Params::new().hash_length(bytes.len()).to_state();

    hasher.update(input_bytes);
    let hash = hasher.finalize();

    // Create a new array containing the first 16 elements from the original array
    bytes.copy_from_slice(hash.as_bytes());

    bytes
}

/// 128 Byte Blake2b Hash
pub(crate) type Blake2b128 = [u8; 16];

/// Computes a BLAKE2b-128 hash of the input bytes.
///
/// # Arguments
/// - `input_bytes`: A slice of bytes to be hashed.
///
/// # Returns
/// An array containing the BLAKE2b-128 hash of the input bytes.
pub(crate) fn blake2b_128(input_bytes: &[u8]) -> Blake2b128 {
    // Where we will actually store the result.
    let mut bytes: Blake2b128 = Blake2b128::default();

    // Generate a unique hash of the data.
    let mut hasher = Params::new().hash_length(bytes.len()).to_state();

    hasher.update(input_bytes);
    let hash = hasher.finalize();

    // Create a new array containing the first 16 elements from the original array
    bytes.copy_from_slice(hash.as_bytes());

    bytes
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
