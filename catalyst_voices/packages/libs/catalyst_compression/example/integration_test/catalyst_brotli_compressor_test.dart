import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(CatalystBrotliCompressor, () {
    const compressor = CatalystBrotliCompressor();
    final rawData = List.generate(1024, (i) => i % 255);

    test('compress and decompress', () async {
      final compressed = await compressor.compress(rawData);
      final decompressed = await compressor.decompress(compressed);

      expect(compressed, isNot(equals(rawData)));
      expect(compressed.length, lessThan(rawData.length));
      expect(decompressed, equals(rawData));
    });
  });
}
