import 'package:catalyst_voices_shared/src/range/range.dart';
import 'package:test/test.dart';

void main() {
  group(Range, () {
    test('contains() returns true for values within range', () {
      const range = Range<num>(min: 10, max: 20);
      expect(range.contains(15), isTrue);
      expect(range.contains(10), isTrue);
      expect(range.contains(20), isTrue);
    });

    test('contains() returns false for values outside range', () {
      const range = Range<num>(min: 10, max: 20);
      expect(range.contains(5), isFalse);
      expect(range.contains(25), isFalse);
    });

    test('contains() handles null min (only upper bound constraint)', () {
      const range = Range<num?>(min: null, max: 20);
      expect(range.contains(-100), isTrue);
      expect(range.contains(20), isTrue);
      expect(range.contains(21), isFalse);
    });

    test('contains() handles null max (only lower bound constraint)', () {
      const range = Range<num?>(min: 10, max: null);
      expect(range.contains(100), isTrue);
      expect(range.contains(10), isTrue);
      expect(range.contains(5), isFalse);
    });

    test('contains() handles both min and max null (infinite range)', () {
      const range = Range<num?>(min: null, max: null);
      expect(range.contains(-1000), isTrue);
      expect(range.contains(0), isTrue);
      expect(range.contains(1000), isTrue);
    });

    test('optionalRangeOf() creates correct range', () {
      final range1 = Range.optionalRangeOf<num>(min: 10, max: 20);
      expect(range1, isNotNull);
      expect(range1!.min, equals(10));
      expect(range1.max, equals(20));

      final range2 = Range.optionalRangeOf<num>(max: 20);
      expect(range2, isNotNull);
      expect(range2!.min, isNull);
      expect(range2.max, equals(20));

      final range3 = Range.optionalRangeOf<num>(min: 10);
      expect(range3, isNotNull);
      expect(range3!.min, equals(10));
      expect(range3.max, isNull);

      final range4 = Range.optionalRangeOf<num>();
      expect(range4, isNull);
    });

    test('Equality check works correctly', () {
      const range1 = Range<num>(min: 10, max: 20);
      const range2 = Range<num>(min: 10, max: 20);
      const range3 = Range<num>(min: 15, max: 25);

      expect(range1, equals(range2));
      expect(range1, isNot(equals(range3)));
    });
  });
}
