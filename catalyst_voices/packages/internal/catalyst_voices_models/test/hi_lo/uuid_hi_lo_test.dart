import 'package:catalyst_voices_models/src/hi_lo/uuid_hi_lo.dart';
import 'package:test/test.dart';

void main() {
  group(UuidHiLo, () {
    test('dashed uuid produces UuidHiLo and reconstructs correctly', () {
      // Given
      const sourceUuid = '0194cbff-df11-7a82-901a-2afd1c05be3d';

      // When
      final hiLo = UuidHiLo.fromV7(sourceUuid);

      // Then
      expect(hiLo.uuid, sourceUuid);
    });

    test('flat uuid produces UuidHiLo and reconstructs correctly', () {
      // Given
      const sourceUuid = '0194cbffdf117a82901a2afd1c05be3d';

      // When
      final hiLo = UuidHiLo.fromV7(sourceUuid);

      // Then
      expect(hiLo.uuid.replaceAll('-', ''), sourceUuid);
    });

    test('non v7 uuid throws exception', () {
      // Given
      const version = 4;
      const sourceUuid = '0194cbff-df11-${version}a82-901a-2afd1c05be3d';

      // When
      UuidHiLo parse() => UuidHiLo.fromV7(sourceUuid);

      // Then
      expect(parse, throwsA(isA<ArgumentError>()));
    });

    test('empty source throws exception', () {
      // Given
      const sourceUuid = '';

      // When
      UuidHiLo parse() => UuidHiLo.fromV7(sourceUuid);

      // Then
      expect(parse, throwsA(isA<ArgumentError>()));
    });

    test('invalid source throws exception', () {
      // Given
      const sourceUuid = 'invalid-uuid';

      // When
      UuidHiLo parse() => UuidHiLo.fromV7(sourceUuid);

      // Then
      expect(parse, throwsA(isA<ArgumentError>()));
    });
  });
}
