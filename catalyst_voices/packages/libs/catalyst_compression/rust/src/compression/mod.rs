//! Rust implementation Catalyst Compression exposing brotli and zstd codecs.

use flutter_rust_bridge::{spawn_blocking_with, DefaultHandler, SimpleThreadPool};
use std::default::Default;

/// Compress the bytes with brotli compression algorithm.
/// Runs the computation by a shared thread poll to avoid blocking the main thread.
///  
/// # Arguments
///
/// - `bytes`: uncompressed bytes.
///
/// # Returns
///
/// Returns compressed bytes as a `Result`.
pub async fn brotli_compress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
   let result = spawn_blocking_with(
        move || brotli_compress_helper(bytes),
        CUSTOM_HANDLER.thread_pool(),
    )
    .await??;

    Ok(result)
}

fn brotli_compress_helper(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let brotli_params = brotli::enc::BrotliEncoderParams::default();
    let mut buffer = Vec::new();
    brotli::BrotliCompress(&mut bytes.as_slice(), &mut buffer, &brotli_params)?;
    Ok(buffer)
}

/// Decompress the bytes with brotli compression algorithm.
/// Runs the computation by a shared thread poll to avoid blocking the main thread.
///  
/// # Arguments
///
/// - `bytes`: brotli compressed bytes.
///
/// # Returns
///
/// Returns uncompressed bytes as `Result`.
pub async fn brotli_decompress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let result = spawn_blocking_with(
        move || brotli_decompress_helper(bytes),
        CUSTOM_HANDLER.thread_pool(),
    )
    .await??;

    Ok(result)
}

fn brotli_decompress_helper(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let mut buffer = Vec::new();
    brotli::BrotliDecompress(&mut bytes.as_slice(), &mut buffer)?;
    Ok(buffer)
}

/// Compress the bytes with zstd compression algorithm.
/// Runs the computation by a shared thread poll to avoid blocking the main thread.
///  
/// # Arguments
///
/// - `bytes`: uncompressed bytes.
///
/// # Returns
///
/// Returns compressed bytes as a `Result`.
pub async fn zstd_compress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let result = spawn_blocking_with(
        move || zstd_compress_helper(bytes),
        CUSTOM_HANDLER.thread_pool(),
    )
    .await??;

    Ok(result)
}

fn zstd_compress_helper(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let compressed = zstd::bulk::compress(&bytes, 0)?;
    Ok(compressed)
}

/// Decompress the bytes with zstd compression algorithm.
/// Runs the computation by a shared thread poll to avoid blocking the main thread.
///  
/// # Arguments
///
/// - `bytes`: zstd compressed bytes.
///
/// # Returns
///
/// Returns uncompressed bytes as `Result`.
pub async fn zstd_decompress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let result = spawn_blocking_with(
        move || zstd_decompress_helper(bytes),
        CUSTOM_HANDLER.thread_pool(),
    )
    .await??;

    Ok(result)
}

fn zstd_decompress_helper(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    let mut buffer = vec![];
    zstd::stream::copy_decode(bytes.as_slice(), &mut buffer)?;
    Ok(buffer)
}

#[cfg(not(target_family = "wasm"))]
flutter_rust_bridge::for_generated::lazy_static! {
    static ref CUSTOM_HANDLER: DefaultHandler<SimpleThreadPool> =
        DefaultHandler::new_simple(Default::default());
}

#[cfg(target_family = "wasm")]
thread_local! {
    static THREAD_POOL: SimpleThreadPool = SimpleThreadPool::new(None, None, Some("compression_wasm_bindgen".to_string()).into(), None)
        .expect("failed to create ThreadPool");
}

#[cfg(target_family = "wasm")]
flutter_rust_bridge::for_generated::lazy_static! {
    static ref CUSTOM_HANDLER: DefaultHandler<&'static std::thread::LocalKey<SimpleThreadPool>> =
        DefaultHandler::new_simple(&THREAD_POOL);
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_brotli_roundtrip() {
        let input = b"hello catalyst compression with brotli".to_vec();
        let compressed = brotli_compress_helper(input.clone()).expect("brotli compress failed");
        assert!(!compressed.is_empty(), "compressed output should not be empty");

        let decompressed = brotli_decompress_helper(compressed).expect("brotli decompress failed");
        assert_eq!(decompressed, input, "decompressed output should match original");
    }

    #[test]
    fn test_zstd_roundtrip() {
        let input = b"hello catalyst compression with zstd".to_vec();
        let compressed = zstd_compress_helper(input.clone()).expect("zstd compress failed");
        assert!(!compressed.is_empty(), "compressed output should not be empty");

        let decompressed = zstd_decompress_helper(compressed).expect("zstd decompress failed");
        assert_eq!(decompressed, input, "decompressed output should match original");
    }

    #[test]
    fn test_brotli_invalid_input() {
        // Brotli should fail to decompress invalid data
        let invalid = b"not valid brotli data".to_vec();
        let result = brotli_decompress_helper(invalid);
        assert!(result.is_err(), "brotli should fail on invalid input");
    }

    #[test]
    fn test_zstd_invalid_input() {
        // Zstd should fail to decompress invalid data
        let invalid = b"not valid zstd data".to_vec();
        let result = zstd_decompress_helper(invalid);
        assert!(result.is_err(), "zstd should fail on invalid input");
    }
}