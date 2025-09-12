import 'package:catalyst_compression/src/catalyst_compressor.dart';
import 'package:catalyst_compression/src/rust/compression.dart' as rust;
import 'package:catalyst_compression/src/rust_initializer.dart';

/// Brotli compressor backed by Rust via `flutter_rust_bridge`.
///
/// Usage:
/// ```dart
/// final c = CatalystBrotliCompressor();
/// final out = await c.compress(data);
/// final restored = await c.decompress(out);
/// ```
class CatalystBrotliCompressor implements CatalystCompressor {
  /// The default constructor for [CatalystBrotliCompressor].
  const CatalystBrotliCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return rust.brotliCompress(bytes: bytes);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return rust.brotliDecompress(bytes: bytes);
  }
}
