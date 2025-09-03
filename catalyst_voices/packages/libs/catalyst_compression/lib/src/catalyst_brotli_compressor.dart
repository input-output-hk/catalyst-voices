import 'package:catalyst_compression/src/catalyst_compressor.dart';
import 'package:catalyst_compression/src/rust/api/compression.dart';
import 'package:catalyst_compression/src/rust_initializer.dart';

class CatalystBrotliCompressor implements CatalystCompressor {
  /// The default constructor for [CatalystBrotliCompressor].
  const CatalystBrotliCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return brotliCompress(bytes: bytes);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return brotliDecompress(bytes: bytes);
  }
}
