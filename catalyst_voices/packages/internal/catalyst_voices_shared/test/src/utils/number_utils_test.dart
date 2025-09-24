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
}
