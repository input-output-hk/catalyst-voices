import 'package:catalyst_voices_models/src/money/currencies.dart';
import 'package:catalyst_voices_models/src/money/money.dart';
import 'package:catalyst_voices_models/src/money/multi_currency_amount.dart';
import 'package:test/test.dart';

void main() {
  group(MultiCurrencyAmount, () {
    const usdm = Currencies.usdm;
    const ada = Currencies.ada;

    final usdm100 = Money.fromMajorUnits(currency: usdm, majorUnits: BigInt.from(100));
    final usdm50 = Money.fromMajorUnits(currency: usdm, majorUnits: BigInt.from(50));
    final ada200 = Money.fromMajorUnits(currency: ada, majorUnits: BigInt.from(200));

    test('empty $MultiCurrencyAmount has no values', () {
      final multi = MultiCurrencyAmount();
      expect(multi.list, isEmpty);
    });

    test('single constructor initializes correctly', () {
      final multi = MultiCurrencyAmount.single(usdm100);
      expect(multi.list.length, 1);
      expect(multi[usdm.code], usdm100);
    });

    test('list constructor initializes correctly', () {
      final multi = MultiCurrencyAmount.list([usdm100, ada200]);
      expect(multi.list.length, 2);
      expect(multi[usdm.code], usdm100);
      expect(multi[ada.code], ada200);
    });

    test('operator[] returns null for missing currency', () {
      final multi = MultiCurrencyAmount();
      expect(multi[usdm.code], isNull);
    });

    test('deepCopy produces independent copy', () {
      final multi = MultiCurrencyAmount.list([usdm100, ada200]);
      final copy = MultiCurrencyAmount.list([
        ...multi.deepCopy().list,
        Money.fromMajorUnits(currency: usdm, majorUnits: BigInt.from(10)),
      ]);

      expect(copy[usdm.code]!.minorUnits, usdm100.minorUnits + BigInt.from(10 * 100));
      expect(multi[usdm.code]!.minorUnits, usdm100.minorUnits); // original unchanged
    });

    test('adding multiple currencies works independently', () {
      final multi = MultiCurrencyAmount.list([usdm100, ada200]);

      expect(multi[usdm.code]!.minorUnits, usdm100.minorUnits);
      expect(multi[ada.code]!.minorUnits, ada200.minorUnits);
    });

    test('zero amounts are automatically removed', () {
      final negativeUsdm50 = Money.fromMajorUnits(
        currency: usdm,
        majorUnits: usdm50.majorUnits * BigInt.from(-1),
      );
      final multi = MultiCurrencyAmount.list([usdm50, negativeUsdm50]);
      expect(multi.list, isEmpty);
    });
  });
}
