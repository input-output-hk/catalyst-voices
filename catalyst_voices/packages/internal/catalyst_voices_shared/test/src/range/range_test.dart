import 'package:catalyst_voices_shared/src/range/range.dart';
import 'package:test/test.dart';

void main() {
  group(ComparableRange, () {
    test('contains() returns true for values within range', () {
      const range = ComparableRange<num>(min: 10, max: 20);
      expect(range.contains(15), isTrue);
      expect(range.contains(10), isTrue);
      expect(range.contains(20), isTrue);
    });

    test('contains() returns false for values outside range', () {
      const range = ComparableRange<num>(min: 10, max: 20);
      expect(range.contains(5), isFalse);
      expect(range.contains(25), isFalse);
    });

    test('Equality check works correctly', () {
      const range1 = ComparableRange<num>(min: 10, max: 20);
      const range2 = ComparableRange<num>(min: 10, max: 20);
      const range3 = ComparableRange<num>(min: 15, max: 25);

      expect(range1, equals(range2));
      expect(range1, isNot(equals(range3)));
    });
  });

  group(NumRange, () {
    test('contains() returns true for constrained range', () {
      const range = NumRange(min: 10, max: 20);
      expect(range.contains(15), isTrue);
      expect(range.contains(10), isTrue);
      expect(range.contains(20), isTrue);
    });

    test('contains() returns false for values outside constrained range', () {
      const range = NumRange(min: 10, max: 20);
      expect(range.contains(5), isFalse);
      expect(range.contains(25), isFalse);
    });

    test('contains() handles null min (only upper bound constraint)', () {
      const range = NumRange<num>(min: null, max: 20);
      expect(range.contains(-100), isTrue);
      expect(range.contains(20), isTrue);
      expect(range.contains(21), isFalse);
    });

    test('contains() handles null max (only lower bound constraint)', () {
      const range = NumRange<num>(min: 10, max: null);
      expect(range.contains(100), isTrue);
      expect(range.contains(10), isTrue);
      expect(range.contains(5), isFalse);
    });

    test('contains() handles both min and max null (infinite range)', () {
      const range = NumRange<num>(min: null, max: null);
      expect(range.contains(-1000), isTrue);
      expect(range.contains(0), isTrue);
      expect(range.contains(1000), isTrue);
    });

    test('Equality check works correctly', () {
      const range1 = NumRange(min: 10, max: 20);
      const range2 = NumRange(min: 10, max: 20);
      const range3 = NumRange<num>(min: null, max: 20);

      expect(range1, equals(range2));
      expect(range1, isNot(equals(range3)));
    });

    test('optionalRangeOf() creates correct NumRange', () {
      final range1 = NumRange.optionalRangeOf(min: 10, max: 20);
      expect(range1, isNotNull);
      expect(range1!.min, equals(10));
      expect(range1.max, equals(20));

      final range2 = NumRange.optionalRangeOf<num>(min: null, max: 20);
      expect(range2, isNotNull);
      expect(range2!.min, isNull);
      expect(range2.max, equals(20));

      final range3 = NumRange.optionalRangeOf<num>(min: 10, max: null);
      expect(range3, isNotNull);
      expect(range3!.min, equals(10));
      expect(range3.max, isNull);

      final range4 = NumRange.optionalRangeOf<num>(min: null, max: null);
      expect(range4, isNull);
    });
  });
}
