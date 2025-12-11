import 'package:catalyst_voices_repositories/src/database/table/converter/string_list_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(StringListConverter, () {
    const converter = StringListConverter();

    group('toSql', () {
      test('returns "[]" for an empty list', () {
        // Given
        const input = <String>[];

        // When
        final result = converter.toSql(input);

        // Then
        expect(result, '[]');
      });

      test('returns valid JSON string for a list with nulls', () {
        // Given
        const input = ['one', null, 'two'];

        // When
        final result = converter.toSql(input);

        // Then
        expect(result, '["one",null,"two"]');
      });

      test('returns valid JSON string for list of only nulls', () {
        // Given
        const input = [null, null];

        // When
        final result = converter.toSql(input);

        // Then
        expect(result, '[null,null]');
      });

      test('escapes special characters correctly', () {
        // Given
        const input = ['Line\nBreak', null, 'Quote"'];

        // When
        final result = converter.toSql(input);

        // Then
        expect(result, r'["Line\nBreak",null,"Quote\""]');
      });
    });

    group('fromSql', () {
      test('returns empty list for empty string', () {
        // Given
        const input = '';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, isEmpty);
      });

      test('parses JSON array with nulls correctly', () {
        // Given
        const input = '["alpha", null, "beta"]';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, ['alpha', null, 'beta']);
      });

      test('parses JSON array of only nulls', () {
        // Given
        const input = '[null, null]';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, [null, null]);
      });

      test('returns empty list for invalid JSON syntax', () {
        // Given
        const input = '{invalid_json}';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, isEmpty);
      });

      test('returns empty list if JSON is valid but not a list', () {
        // Given
        const input = '{"key": "value"}';

        // When
        final result = converter.fromSql(input);

        // Then
        expect(result, isEmpty);
      });

      test('handles mixed types by casting gracefully', () {
        // Given: A JSON list with a number, which isn't a String or Null
        const input = '["a", 1, null]';

        // When
        final result = converter.fromSql(input);

        expect(result, isEmpty);
      });
    });
  });
}
