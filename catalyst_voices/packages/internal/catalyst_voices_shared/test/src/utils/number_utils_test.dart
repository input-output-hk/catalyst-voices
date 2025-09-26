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

  group('DoubleExt', () {
    group('truncateToDecimals', () {
      test('truncates to 0 decimals', () {
        expect(12.987.truncateToDecimals(0), 12.0);
        expect(99.999.truncateToDecimals(0), 99.0);
        expect(-12.987.truncateToDecimals(0), -12.0);
      });

      test('truncates to 1 decimal', () {
        expect(12.987.truncateToDecimals(1), 12.9);
        expect(99.999.truncateToDecimals(1), 99.9);
        expect(-12.987.truncateToDecimals(1), -12.9);
      });

      test('truncates to 2 decimals', () {
        expect(12.987.truncateToDecimals(2), 12.98);
        expect(99.991.truncateToDecimals(2), 99.99);
        expect(-12.987.truncateToDecimals(2), -12.98);
      });

      test('returns same number if already within decimals', () {
        expect(12.5.truncateToDecimals(1), 12.5);
        expect(42.42.truncateToDecimals(2), 42.42);
      });

      test('handles very small numbers', () {
        expect(0.0001234.truncateToDecimals(4), 0.0001);
        expect(0.0001234.truncateToDecimals(6), 0.000123);
      });

      test('handles large numbers', () {
        expect(1234567.89123.truncateToDecimals(2), 1234567.89);
        expect(987654321.123456.truncateToDecimals(4), 987654321.1234);
      });
    });
  });
}
