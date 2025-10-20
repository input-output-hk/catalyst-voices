/// Fake implementations of compression interfaces for testing.
///
/// These fakes provide no-op compression implementations that simply return
/// the input bytes unchanged, useful for testing without actual compression.
library;

import 'package:catalyst_compression/catalyst_compression.dart';

/// A fake implementation of [CatalystCompressor] for testing.
///
/// This fake returns the input bytes unchanged for both compress and decompress
/// operations, making tests faster and more predictable.
final class FakeCompressor implements CatalystCompressor {
  /// Creates a fake compressor.
  const FakeCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async => bytes;

  @override
  Future<List<int>> decompress(List<int> bytes) async => bytes;
}
