import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/money/currency.dart';
import 'package:catalyst_voices_models/src/money/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Money, () {
    group('constructors', () {
      test('from minorUnits', () {
        final money = Money(
          currency: const Currency.usd(),
          minorUnits: BigInt.from(12345),
        );
        expect(money.currency, const Currency.usd());
        expect(money.minorUnits, BigInt.from(12345));
      });

      test('fromMajorUnits', () {
        final money = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(123),
        );
        expect(money.minorUnits, BigInt.from(12300)); // USD has 2 decimals
      });

      test('zero factory', () {
        final money = Money.zero(currency: const Currency.usd());
        expect(money.isZero, isTrue);
        expect(money.minorUnits, BigInt.zero);
      });
    });

    group('arithmetic operators', () {
      test('addition with same currency', () {
        final usd100 = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final usd50 = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(50),
        );
        final sum = usd100 + usd50;
        expect(sum.minorUnits, usd100.minorUnits + usd50.minorUnits);
      });

      test('addition throws on different currencies', () {
        final usd100 = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final ada100 = Money.fromMajorUnits(
          currency: const Currency.ada(),
          majorUnits: BigInt.from(100),
        );
        expect(() => usd100 + ada100, throwsArgumentError);
      });

      test('subtraction with same currency', () {
        final usd100 = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final usd50 = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(50),
        );
        final result = usd100 - usd50;
        expect(result.minorUnits, usd100.minorUnits - usd50.minorUnits);
      });

      test('subtraction throws on different currencies', () {
        final usd100 = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final ada100 = Money.fromMajorUnits(
          currency: const Currency.ada(),
          majorUnits: BigInt.from(100),
        );
        expect(() => usd100 - ada100, throwsArgumentError);
      });
    });

    group('comparison operators', () {
      final usd100 = Money.fromMajorUnits(
        currency: const Currency.usd(),
        majorUnits: BigInt.from(100),
      );
      final usd200 = Money.fromMajorUnits(
        currency: const Currency.usd(),
        majorUnits: BigInt.from(200),
      );

      test('< operator', () {
        expect(usd100 < usd200, isTrue);
      });
      test('<= operator', () {
        expect(usd100 <= usd200, isTrue);
        expect(usd100 <= usd100, isTrue);
      });
      test('> operator', () {
        expect(usd200 > usd100, isTrue);
      });
      test('>= operator', () {
        expect(usd200 >= usd100, isTrue);
        expect(usd100 >= usd100, isTrue);
      });
      test('compareTo', () {
        expect(usd100.compareTo(usd200), lessThan(0));
        expect(usd200.compareTo(usd100), greaterThan(0));
        expect(usd100.compareTo(usd100), 0);
      });
    });

    group('formatting', () {
      test('format', () {
        final usd = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(123),
        );
        expect(usd.format(), '123.00');

        final ada = Money.fromMajorUnits(
          currency: const Currency.ada(),
          majorUnits: BigInt.from(123),
        );
        expect(ada.format(), '123');
      });

      test('formatDecimal', () {
        final usd = Money(
          currency: const Currency.usd(),
          minorUnits: BigInt.from(100012345),
        );
        expect(usd.formatDecimal(), '1,000,123.45');

        final ada = Money(
          currency: const Currency.ada(),
          minorUnits: BigInt.from(1000123456789),
        );
        expect(ada.formatDecimal(), '1,000,123.456789');
      });

      test('toString returns money with currency symbol', () {
        final money = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(123),
        );
        expect(money.toString(), r'$123.00');
      });
    });
  });

  group('CoinExt', () {
    test('toMoney converts Coin to Money with ADA', () {
      const coin = Coin(123456789);
      final money = coin.toMoney();
      expect(money.currency, const Currency.ada());
      expect(money.minorUnits, BigInt.from(123456789));
    });
  });
}
