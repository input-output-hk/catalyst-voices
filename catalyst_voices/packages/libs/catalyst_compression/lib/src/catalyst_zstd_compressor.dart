import 'package:catalyst_compression/src/catalyst_compressor.dart';
import 'package:catalyst_compression/src/rust/api/compression.dart';
import 'package:catalyst_compression/src/rust_initializer.dart';

/// The rust (native) implementation of zstd compressor.
class CatalystZstdCompressor implements CatalystCompressor {
  /// The default constructor for [CatalystZstdCompressor].
  const CatalystZstdCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return zstdCompress(bytes: bytes);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return zstdDecompress(bytes: bytes);
  }
}
