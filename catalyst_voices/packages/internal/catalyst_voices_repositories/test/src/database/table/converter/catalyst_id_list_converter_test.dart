//ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/catalyst_id_list_converter.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(CatalystIdListConverter, () {
    late CatalystIdListConverter converter;

    // Test Data
    final id1 = _createTestAuthor(name: 'alice', role0KeySeed: 1);
    final id2 = _createTestAuthor(name: 'bob', role0KeySeed: 2);
    final idWithComma = _createTestAuthor(name: 'doe,john', role0KeySeed: 3);

    setUp(() {
      converter = const CatalystIdListConverter();
    });

    group('toSql', () {
      test('returns "[]" when the input list is empty', () {
        // Given
        const input = <CatalystId>[];

        // When
        final result = converter.toSql(input);

        // Then
        expect(result, '[]');
      });

      test('returns a JSON array of strings when the input list has values', () {
        // Given
        final input = [id1, id2];

        // When
        final result = converter.toSql(input);

        // Then
        final decoded = jsonDecode(result);
        expect(decoded, isA<List<dynamic>>());
        expect(decoded, hasLength(2));
        expect(decoded[0], id1.toString());
        expect(decoded[1], id2.toString());
      });

      test('correctly handles CatalystId with a comma in the username', () {
        // Given
        // This simulates the critical edge case that broke the old CSV format
        final input = [id1, idWithComma];

        // When
        final result = converter.toSql(input);

        // Then
        final decoded = jsonDecode(result);
        expect(decoded, hasLength(2));
        expect(decoded[1], idWithComma.toString());

        // Verify the raw string actually contains the comma inside the JSON string
        expect(result, contains('doe,john'));
      });
    });

    group('fromSql', () {
      test('returns an empty list when the input string is empty', () {
        // Given
        const input = '';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, isEmpty);
      });

      test('returns an empty list when the input is an empty JSON array "[]"', () {
        // Given
        const input = '[]';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, isEmpty);
      });

      test('returns an empty list when the input is valid JSON but not a list', () {
        // Given
        const input = '{}';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, isEmpty);
      });

      test('returns a list of CatalystId when the input is a valid JSON array', () {
        // Given
        final input = jsonEncode([id1.toString(), id2.toString()]);

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, hasLength(2));
        expect(result[0], equals(id1));
        expect(result[1], equals(id2));
      });

      test('correctly parses CatalystId with a comma in the username from JSON', () {
        // Given
        final input = jsonEncode([id1.toString(), idWithComma.toString()]);

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, hasLength(2));
        expect(result[1], equals(idWithComma));
        expect(result[1].username, equals('doe,john'));
      });

      test('returns only valid IDs when the input contains invalid URIs', () {
        // Given
        final input = jsonEncode([id1.toString(), 'invalid_uri', id2.toString()]);

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, hasLength(2));
        expect(result[0], equals(id1));
        expect(result[1], equals(id2));
      });
    });
  });
}

CatalystId _createTestAuthor({
  String? name,
  int role0KeySeed = 0,
}) {
  final buffer = StringBuffer('id.catalyst://');
  final role0Key = Uint8List.fromList(List.filled(32, role0KeySeed));

  if (name != null) {
    buffer
      ..write(name)
      ..write('@');
  }

  buffer
    ..write('preprod.cardano/')
    ..write(base64UrlNoPadEncode(role0Key));

  return CatalystId.parse(buffer.toString());
}
