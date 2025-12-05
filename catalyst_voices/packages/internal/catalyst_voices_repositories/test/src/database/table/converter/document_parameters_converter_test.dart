//ignore_for_file: avoid_dynamic_calls
import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/document_parameters_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocumentParametersConverter', () {
    late DocumentParametersConverter converter;

    // Sample Data
    const ref1 = SignedDocumentRef(id: 'doc-1', ver: 'ver-1');
    const ref2 = SignedDocumentRef(id: 'doc-2', ver: 'ver-2');

    setUp(() {
      converter = const DocumentParametersConverter();
    });

    group('toSql', () {
      test('returns "[]" when the parameters set is empty', () {
        // Given
        const input = DocumentParameters();

        // When
        final result = converter.toSql(input);

        // Then
        expect(result, '[]');
      });

      test('returns a JSON array of DTO objects when parameters exist', () {
        // Given
        final input = DocumentParameters({ref1, ref2});

        // When
        final result = converter.toSql(input);

        // Then
        final decoded = jsonDecode(result);
        expect(decoded, isA<List<dynamic>>());
        expect(decoded, hasLength(2));

        // Verify content existence (order not guaranteed in Sets)
        final item1 = (decoded as List).firstWhere(
          (e) => e['id'] == 'doc-1',
          orElse: () => null,
        );

        expect(item1, isNotNull);
        expect(item1['ver'], 'ver-1');
        expect(item1['type'], 'signed');
      });
    });

    group('fromSql', () {
      test('returns empty DocumentParameters when the input string is empty', () {
        // Given
        const input = '';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result.set, isEmpty);
      });

      test('returns empty DocumentParameters when the input is "[]"', () {
        // Given
        const input = '[]';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result.set, isEmpty);
      });

      test('returns empty DocumentParameters when the input is not a list', () {
        // Given
        const input = '{}';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result.set, isEmpty);
      });

      test('returns populated DocumentParameters when the input is valid JSON', () {
        // Given
        final rawJson = [
          {'id': 'doc-1', 'ver': 'ver-1', 'type': 'signed'},
          {'id': 'doc-2', 'ver': 'ver-2', 'type': 'signed'},
        ];
        final input = jsonEncode(rawJson);

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result.set, hasLength(2));
        expect(result.set.contains(ref1), isTrue);
        expect(result.set.contains(ref2), isTrue);
      });
    });
  });
}
