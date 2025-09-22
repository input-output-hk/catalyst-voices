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
        final a = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final b = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(50),
        );
        final sum = a + b;
        expect(sum.minorUnits, a.minorUnits + b.minorUnits);
      });

      test('addition throws on different currencies', () {
        final a = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final b = Money.fromMajorUnits(
          currency: const Currency.ada(),
          majorUnits: BigInt.from(100),
        );
        expect(() => a + b, throwsArgumentError);
      });

      test('subtraction with same currency', () {
        final a = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final b = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(50),
        );
        final result = a - b;
        expect(result.minorUnits, a.minorUnits - b.minorUnits);
      });

      test('subtraction throws on different currencies', () {
        final a = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(100),
        );
        final b = Money.fromMajorUnits(
          currency: const Currency.ada(),
          majorUnits: BigInt.from(100),
        );
        expect(() => a - b, throwsArgumentError);
      });
    });

    group('comparison operators', () {
      final a = Money.fromMajorUnits(
        currency: const Currency.usd(),
        majorUnits: BigInt.from(100),
      );
      final b = Money.fromMajorUnits(
        currency: const Currency.usd(),
        majorUnits: BigInt.from(200),
      );

      test('< operator', () {
        expect(a < b, isTrue);
      });
      test('<= operator', () {
        expect(a <= b, isTrue);
        expect(a <= a, isTrue);
      });
      test('> operator', () {
        expect(b > a, isTrue);
      });
      test('>= operator', () {
        expect(b >= a, isTrue);
        expect(a >= a, isTrue);
      });
      test('compareTo', () {
        expect(a.compareTo(b), lessThan(0));
        expect(b.compareTo(a), greaterThan(0));
        expect(a.compareTo(a), 0);
      });
    });

    group('formatting', () {
      test('format', () {
        final usd = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(123),
        );
        expect(usd.format(), r'$123.00');

        final ada = Money.fromMajorUnits(
          currency: const Currency.ada(),
          majorUnits: BigInt.from(123),
        );
        expect(ada.format(), '₳123');
      });

      test('formatDecimal', () {
        final usd = Money(
          currency: const Currency.usd(),
          minorUnits: BigInt.from(100012345),
        );
        expect(usd.formatDecimal(), r'$1,000,123.45');

        final ada = Money(
          currency: const Currency.ada(),
          minorUnits: BigInt.from(1000123456789),
        );
        expect(ada.formatDecimal(), '₳1,000,123.456789');
      });

      test('toString returns format()', () {
        final money = Money.fromMajorUnits(
          currency: const Currency.usd(),
          majorUnits: BigInt.from(123),
        );
        expect(money.toString(), money.format());
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
