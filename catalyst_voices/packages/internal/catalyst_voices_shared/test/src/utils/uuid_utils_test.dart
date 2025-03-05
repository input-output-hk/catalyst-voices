import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(UuidUtils, () {
    test('returns correct datetime for uuid v7', () {
      // Given
      final sourceDateTime = DateTime.utc(2025, 2, 3, 15, 34);
      final config = V7Options(sourceDateTime.millisecondsSinceEpoch, null);
      final uuid = const Uuid().v7(config: config);

      // When
      final dateTime = UuidUtils.dateTime(uuid);

      // Then
      expect(dateTime, sourceDateTime);
    });

    test('returns correct datetime for uuid v7 with not dashes', () {
      // Given
      final sourceDateTime = DateTime.utc(2025, 2, 3, 15, 34);
      final config = V7Options(sourceDateTime.millisecondsSinceEpoch, null);
      final uuid = const Uuid().v7(config: config).replaceAll('-', '');

      // When
      final dateTime = UuidUtils.dateTime(uuid, noDashes: true);

      // Then
      expect(dateTime, sourceDateTime);
    });

    test('throws exception for invalid source', () {
      // Given
      const uuid = '123oneTwo';

      // When
      void parse() => UuidUtils.dateTime(uuid);

      // Then
      expect(parse, throwsA(isA<FormatException>()));
    });

    test('throws exception for empty source', () {
      // Given
      const uuid = '';

      // When
      void parse() => UuidUtils.dateTime(uuid);

      // Then
      expect(parse, throwsA(isA<FormatException>()));
    });

    test('throws exception for uuid v4', () {
      // Given
      final uuid = const Uuid().v4();

      // When
      void parse() => UuidUtils.dateTime(uuid);

      // Then
      expect(parse, throwsA(isA<ArgumentError>()));
    });
  });
}
