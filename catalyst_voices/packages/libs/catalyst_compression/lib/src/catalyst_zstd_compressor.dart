import 'package:catalyst_compression/src/catalyst_compressor.dart';
import 'package:catalyst_compression/src/rust/compression.dart' as rust;
import 'package:catalyst_compression/src/rust_initializer.dart';

/// Zstd compressor backed by Rust via `flutter_rust_bridge`.
///
/// Usage:
/// ```dart
/// final c = CatalystZstdCompressor();
/// final out = await c.compress(data);
/// final restored = await c.decompress(out);
/// ```
class CatalystZstdCompressor implements CatalystCompressor {
  /// The default constructor for [CatalystZstdCompressor].
  const CatalystZstdCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return rust.zstdCompress(bytes: bytes);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    await RustInitializer.ensureInitialized();
    return rust.zstdDecompress(bytes: bytes);
  }
}
