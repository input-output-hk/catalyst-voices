import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';

void main() {
  group(NumberUtils, () {
    group('isDoubleMultipleOf', () {
      test('returns true for exact multiples', () {
        expect(
          NumberUtils.isDoubleMultipleOf(value: 10, multipleOf: 2),
          isTrue,
        );
        expect(
          NumberUtils.isDoubleMultipleOf(value: 15, multipleOf: 5),
          isTrue,
        );
        expect(
          NumberUtils.isDoubleMultipleOf(value: 7.5, multipleOf: 2.5),
          isTrue,
        );
      });

      test('returns false for non-multiples', () {
        expect(
          NumberUtils.isDoubleMultipleOf(value: 10, multipleOf: 3),
          isFalse,
        );
        expect(
          NumberUtils.isDoubleMultipleOf(value: 7.1, multipleOf: 2.5),
          isFalse,
        );
      });

      test('handles division by zero gracefully', () {
        expect(
          NumberUtils.isDoubleMultipleOf(value: 10, multipleOf: 0),
          isFalse,
        );
      });

      test('respects tolerance for floating-point precision', () {
        // 0.30000000000000004 is a common floating point imprecision
        expect(
          NumberUtils.isDoubleMultipleOf(value: 0.30000000000000004, multipleOf: 0.1),
          isTrue,
        );
      });

      test('fails when tolerance is too strict', () {
        expect(
          NumberUtils.isDoubleMultipleOf(
            value: 0.30000000000000004,
            multipleOf: 0.1,
            tolerance: 0,
          ),
          isFalse,
        );
      });

      test('works with negative numbers', () {
        expect(
          NumberUtils.isDoubleMultipleOf(value: -10, multipleOf: -2),
          isTrue,
        );
        expect(
          NumberUtils.isDoubleMultipleOf(value: -10, multipleOf: 2),
          isTrue,
        );
        expect(
          NumberUtils.isDoubleMultipleOf(value: 10, multipleOf: -2),
          isTrue,
        );
      });
    });
  });

  group('StringDoubleExt', () {
    group('normalizeDecimalSeparator', () {
      test('keeps single dot unchanged', () {
        expect('123.45'.normalizeDecimalSeparator(), '123.45');
      });

      test('replaces commas with dots', () {
        expect('123,45'.normalizeDecimalSeparator(), '123.45');
      });

      test('removes all dots except the last one', () {
        expect('1.2.3.4'.normalizeDecimalSeparator(), '123.4');
      });

      test('works with mixed commas and dots', () {
        expect('1,234.56'.normalizeDecimalSeparator(), '1234.56');
        expect('1.234,56'.normalizeDecimalSeparator(), '1234.56');
      });

      test('removes extra dots after replacing commas', () {
        expect('1,2,3,4'.normalizeDecimalSeparator(), '123.4');
      });

      test('string without separators remains unchanged', () {
        expect('1234'.normalizeDecimalSeparator(), '1234');
      });

      test('handles leading/trailing spaces and mixed symbols', () {
        expect('  1,234.56 '.trim().normalizeDecimalSeparator(), '1234.56');
      });

      test('empty string returns empty', () {
        expect(''.normalizeDecimalSeparator(), '');
      });
    });
  });
}
