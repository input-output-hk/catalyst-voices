import 'package:catalyst_compression/catalyst_compression.dart';

final class FakeCompressor implements CatalystCompressor {
  const FakeCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async => bytes;

  @override
  Future<List<int>> decompress(List<int> bytes) async => bytes;
}
