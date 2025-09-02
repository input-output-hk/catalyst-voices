import 'package:catalyst_compression_native/src/rust/api/compression.dart';
import 'package:catalyst_compression_native/src/rust/frb_generated.dart';
import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';

/// The rust (native) implementation of brotli compressor.
class RustBrotliCompressor implements CatalystCompressor {
  /// The default constructor for [RustBrotliCompressor].
  const RustBrotliCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    await _RustInitializer.ensureInitialized();
    return brotliCompress(bytes: bytes);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    await _RustInitializer.ensureInitialized();
    return brotliDecompress(bytes: bytes);
  }
}

/// The rust (native) implementation of zstd compressor.
class RustZstdCompressor implements CatalystCompressor {
  /// The default constructor for [RustZstdCompressor].
  const RustZstdCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    await _RustInitializer.ensureInitialized();
    return zstdCompress(bytes: bytes);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    await _RustInitializer.ensureInitialized();
    return zstdDecompress(bytes: bytes);
  }
}

class _RustInitializer {
  static Future<void>? _initFuture;

  const _RustInitializer._();

  static Future<void> ensureInitialized() async {
    return _initFuture ??= RustLib.init();
  }
}
