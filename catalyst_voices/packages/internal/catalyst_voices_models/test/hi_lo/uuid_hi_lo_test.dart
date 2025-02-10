import 'package:catalyst_voices_models/src/hi_lo/uuid_hi_lo.dart';
import 'package:test/test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

final _bigIntMinValue64 = BigInt.parse('-9223372036854775808');
final _bigIntMaxValue64 = BigInt.parse('9223372036854775807');
const _bigInt64Reason = 'BigInt value exceeds the range of 64 bits. '
    'SQLite BigInt has 64 bit limit';

void main() {
  group(UuidHiLo, () {
    test('dashed uuid produces UuidHiLo and reconstructs correctly', () {
      // Given
      const sourceUuid = '0194cbff-df11-7a82-901a-2afd1c05be3d';

      // When
      final hiLo = UuidHiLo.from(sourceUuid);

      // Then
      expect(hiLo.uuid, sourceUuid);
    });

    test('flat uuid produces UuidHiLo and reconstructs correctly', () {
      // Given
      const sourceUuid = '0194cbffdf117a82901a2afd1c05be3d';

      // When
      final hiLo = UuidHiLo.from(sourceUuid);

      // Then
      expect(hiLo.uuid.replaceAll('-', ''), sourceUuid);
    });

    test('uuid v4 works correctly', () {
      // Given
      final sourceUuid = const Uuid().v4();

      // When
      UuidHiLo parse() => UuidHiLo.from(sourceUuid);

      // Then
      expect(parse, returnsNormally);
    });

    test('empty source throws exception', () {
      // Given
      const sourceUuid = '';

      // When
      UuidHiLo parse() => UuidHiLo.from(sourceUuid);

      // Then
      expect(parse, throwsA(isA<ArgumentError>()));
    });

    test('invalid source throws exception', () {
      // Given
      const sourceUuid = 'invalid-uuid';

      // When
      UuidHiLo parse() => UuidHiLo.from(sourceUuid);

      // Then
      expect(parse, throwsA(isA<ArgumentError>()));
    });

    test('dateTime is recovered correctly', () {
      // Given
      final dateTime = DateTime(2025, 2, 3, 15, 34);
      final config = V7Options(dateTime.millisecondsSinceEpoch, null);
      final uuid = const Uuid().v7(config: config);

      // When
      final hiLo = UuidHiLo.from(uuid);

      // Then
      expect(hiLo.dateTime, dateTime);
    });

    test('non v7 uuid dateTime throws exception', () {
      // Given
      final uuid = const Uuid().v4();

      // When
      final hiLo = UuidHiLo.from(uuid);

      DateTime extract() => hiLo.dateTime;

      // Then
      expect(extract, throwsA(isA<StateError>()));
    });

    test('high and low does not exceeds 64 bits', () {
      // Given
      final uuid = const Uuid().v7();

      // When
      final hiLo = UuidHiLo.from(uuid);

      // Then
      expect(
        hiLo.high > _bigIntMinValue64 && hiLo.high < _bigIntMaxValue64,
        isTrue,
        reason: _bigInt64Reason,
      );
      expect(
        hiLo.low > _bigIntMinValue64 && hiLo.low < _bigIntMaxValue64,
        isTrue,
        reason: _bigInt64Reason,
      );
    });
  });
}
