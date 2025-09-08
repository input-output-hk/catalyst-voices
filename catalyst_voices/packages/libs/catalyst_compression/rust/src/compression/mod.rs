//! Rust implementation Catalyst Compression exposing brotli and zstd codecs.

use flutter_rust_bridge::spawn_blocking_with;
use flutter_rust_bridge::DefaultHandler;
use flutter_rust_bridge::SimpleThreadPool;
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
    static THREAD_POOL: SimpleThreadPool = Default::default();
}

#[cfg(target_family = "wasm")]
flutter_rust_bridge::for_generated::lazy_static! {
    static ref CUSTOM_HANDLER: DefaultHandler<&'static std::thread::LocalKey<SimpleThreadPool>> =
        DefaultHandler::new_simple(&THREAD_POOL);
}
