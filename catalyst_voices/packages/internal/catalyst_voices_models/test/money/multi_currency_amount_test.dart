import 'package:catalyst_voices_models/src/money/currency.dart';
import 'package:catalyst_voices_models/src/money/money.dart';
import 'package:catalyst_voices_models/src/money/multi_currency_amount.dart';
import 'package:test/test.dart';

void main() {
  group(MultiCurrencyAmount, () {
    const usd = Currency.usd();
    const ada = Currency.ada();

    final usd100 = Money.fromMajorUnits(currency: usd, majorUnits: BigInt.from(100));
    final usd50 = Money.fromMajorUnits(currency: usd, majorUnits: BigInt.from(50));
    final ada200 = Money.fromMajorUnits(currency: ada, majorUnits: BigInt.from(200));

    test('empty $MultiCurrencyAmount has no values', () {
      final multi = MultiCurrencyAmount();
      expect(multi.list, isEmpty);
    });

    test('single constructor initializes correctly', () {
      final multi = MultiCurrencyAmount.single(usd100);
      expect(multi.list.length, 1);
      expect(multi[usd.isoCode], usd100);
    });

    test('list constructor initializes correctly', () {
      final multi = MultiCurrencyAmount.list([usd100, ada200]);
      expect(multi.list.length, 2);
      expect(multi[usd.isoCode], usd100);
      expect(multi[ada.isoCode], ada200);
    });

    test('adding money sums amounts for same currency', () {
      final multi = MultiCurrencyAmount.single(usd100)..add(usd50);
      final total = multi[usd.isoCode]!;
      expect(total.minorUnits, usd100.minorUnits + usd50.minorUnits);
    });

    test('subtracting money decreases amount and removes zero amounts', () {
      final multi = MultiCurrencyAmount.single(usd100)..subtract(usd50);
      expect(multi[usd.isoCode]!.minorUnits, usd50.minorUnits);

      multi.subtract(usd50);
      expect(multi[usd.isoCode], isNull);
    });

    test('operator[] returns null for missing currency', () {
      final multi = MultiCurrencyAmount();
      expect(multi[usd.isoCode], isNull);
    });

    test('deepCopy produces independent copy', () {
      final multi = MultiCurrencyAmount.list([usd100, ada200]);
      final copy = multi.deepCopy()
        ..add(Money.fromMajorUnits(currency: usd, majorUnits: BigInt.from(10)));

      expect(copy[usd.isoCode]!.minorUnits, usd100.minorUnits + BigInt.from(10 * 100));
      expect(multi[usd.isoCode]!.minorUnits, usd100.minorUnits); // original unchanged
    });

    test('adding multiple currencies works independently', () {
      final multi = MultiCurrencyAmount()
        ..add(usd100)
        ..add(ada200);

      expect(multi[usd.isoCode]!.minorUnits, usd100.minorUnits);
      expect(multi[ada.isoCode]!.minorUnits, ada200.minorUnits);
    });

    test('zero amounts are automatically removed', () {
      final multi = MultiCurrencyAmount.single(usd50)..subtract(usd50);
      expect(multi.list, isEmpty);
    });
  });
}
