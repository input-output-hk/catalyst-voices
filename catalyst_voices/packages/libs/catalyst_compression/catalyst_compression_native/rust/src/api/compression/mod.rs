//! Rust implementation Catalyst Compression exposing brotli and zstd codecs.

// use flutter_rust_bridge::{frb, spawn_blocking_with};

// use crate::frb_generated::FLUTTER_RUST_BRIDGE_HANDLER;

/// Compress the bytes with brotli compression algorithm.
///  
/// # Arguments
///
/// - `bytes`: uncompressed bytes.
///
/// # Returns
///
/// Returns compressed bytes as a `Result`.
pub async fn brotli_compress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    Ok(bytes)
}

/// Decompress the bytes with brotli compression algorithm.
///  
/// # Arguments
///
/// - `bytes`: brotli compressed bytes.
///
/// # Returns
///
/// Returns uncompressed bytes as `Result`.
pub async fn brotli_decompress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    Ok(bytes)
}

/// Compress the bytes with zstd compression algorithm.
///  
/// # Arguments
///
/// - `bytes`: uncompressed bytes.
///
/// # Returns
///
/// Returns compressed bytes as a `Result`.
pub async fn zstd_compress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    Ok(bytes)
}

/// Decompress the bytes with zstd compression algorithm.
///  
/// # Arguments
///
/// - `bytes`: zstd compressed bytes.
///
/// # Returns
///
/// Returns uncompressed bytes as `Result`.
pub async fn zstd_decompress(bytes: Vec<u8>) -> anyhow::Result<Vec<u8>> {
    Ok(bytes)
}