import 'package:catalyst_compression_native/catalyst_compression_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(CatalystCompressionNative, () {
    final compression = CatalystCompressionNative();
    final rawData = List.generate(1024, (i) => i % 255);

    group('brotli', () {
      test('compress and decompress', () async {
        final compressor = compression.brotli;

        final compressed = await compressor.compress(rawData);
        final decompressed = await compressor.decompress(compressed);

        expect(compressed, isNot(equals(rawData)));
        expect(compressed.length, lessThan(rawData.length));
        expect(decompressed, equals(rawData));
      });
    });

    group('zstd', () {
      test('compress and decompress', () async {
        final compressor = compression.zstd;

        final compressed = await compressor.compress(rawData);
        final decompressed = await compressor.decompress(compressed);

        expect(compressed, isNot(equals(rawData)));
        expect(compressed.length, lessThan(rawData.length));
        expect(decompressed, equals(rawData));
      });
    });
  });
}
