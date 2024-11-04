import 'package:catalyst_voices_shared/src/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('separatedBy', () {
    test('adds given separator between each item in the list', () {
      // Given
      const source = [1, 2, 3, 4];
      const separator = 99;
      const expectedList = [1, separator, 2, separator, 3, separator, 4];

      // When
      final separatedSource = source.separatedBy(separator);

      // Then
      expect(separatedSource, expectedList);
    });

    test('adds nothing when source is empty', () {
      // Given
      const source = <int>[];
      const separator = 99;
      const expectedList = <int>[];

      // When
      final separatedSource = source.separatedBy(separator);

      // Then
      expect(separatedSource, expectedList);
    });

    test('adds nothing when source has one item', () {
      // Given
      const source = <int>[1];
      const separator = 99;
      const expectedList = <int>[1];

      // When
      final separatedSource = source.separatedBy(separator);

      // Then
      expect(separatedSource, expectedList);
    });
  });

  group('separatedByIndexed', () {
    test('inserts correctly separator base on index', () {
      // Given
      const source = [1, 2, 3, 4];
      const expectedList = [1, 0, 2, 1, 3, 2, 4];

      // When
      final separatedSource = source.separatedByIndexed((index, _) => index);

      // Then
      expect(separatedSource, expectedList);
    });

    test('adds nothing when source is empty', () {
      // Given
      const source = <int>[];
      const separator = 99;
      const expectedList = <int>[];

      // When
      final separatedSource = source.separatedByIndexed((_, __) => separator);

      // Then
      expect(separatedSource, expectedList);
    });

    test('adds nothing when source has one item', () {
      // Given
      const source = <int>[1];
      const separator = 99;
      const expectedList = <int>[1];

      // When
      final separatedSource = source.separatedByIndexed((_, __) => separator);

      // Then
      expect(separatedSource, expectedList);
    });
  });
}
