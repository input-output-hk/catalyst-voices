import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/money/currencies.dart';
import 'package:catalyst_voices_models/src/money/money_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Money, () {
    group('constructors', () {
      test('from minorUnits', () {
        final money = Money(
          currency: Currencies.usdm,
          minorUnits: BigInt.from(12345),
        );
        expect(money.currency, Currencies.usdm);
        expect(money.minorUnits, BigInt.from(12345));
      });

      test('fromMajorUnits', () {
        final money = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(123),
        );
        expect(money.minorUnits, BigInt.from(12300)); // USD has 2 decimals
      });

      test('zero factory', () {
        final money = Money.zero(currency: Currencies.usdm);
        expect(money.isZero, isTrue);
        expect(money.minorUnits, BigInt.zero);
      });
    });

    group('arithmetic operators', () {
      test('addition with same currency', () {
        final usdm100 = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(100),
        );
        final usdm50 = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(50),
        );
        final sum = usdm100 + usdm50;
        expect(sum.minorUnits, usdm100.minorUnits + usdm50.minorUnits);
      });

      test('addition throws on different currencies', () {
        final usdm100 = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(100),
        );
        final ada100 = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(100),
        );
        expect(() => usdm100 + ada100, throwsArgumentError);
      });

      test('subtraction with same currency', () {
        final usdm100 = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(100),
        );
        final usdm50 = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(50),
        );
        final result = usdm100 - usdm50;
        expect(result.minorUnits, usdm100.minorUnits - usdm50.minorUnits);
      });

      test('subtraction throws on different currencies', () {
        final usdm100 = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(100),
        );
        final ada100 = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(100),
        );
        expect(() => usdm100 - ada100, throwsArgumentError);
      });
    });

    group('comparison operators', () {
      final usdm100 = Money.fromMajorUnits(
        currency: Currencies.usdm,
        majorUnits: BigInt.from(100),
      );
      final usdm200 = Money.fromMajorUnits(
        currency: Currencies.usdm,
        majorUnits: BigInt.from(200),
      );

      test('< operator', () {
        expect(usdm100 < usdm200, isTrue);
      });
      test('<= operator', () {
        expect(usdm100 <= usdm200, isTrue);
        expect(usdm100 <= usdm100, isTrue);
      });
      test('> operator', () {
        expect(usdm200 > usdm100, isTrue);
      });
      test('>= operator', () {
        expect(usdm200 >= usdm100, isTrue);
        expect(usdm100 >= usdm100, isTrue);
      });
      test('compareTo', () {
        expect(usdm100.compareTo(usdm200), lessThan(0));
        expect(usdm200.compareTo(usdm100), greaterThan(0));
        expect(usdm100.compareTo(usdm100), 0);
      });
    });

    group('formatting', () {
      test('format', () {
        final usdm = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(123),
        );
        expect(usdm.format(), '123.00');

        final ada = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(123),
        );
        expect(ada.format(), '123');
      });

      test('formatDecimal', () {
        final usdm = Money(
          currency: Currencies.usdm,
          minorUnits: BigInt.from(100012345),
        );
        expect(usdm.formatDecimal(), '1,000,123.45');

        final ada = Money(
          currency: Currencies.ada,
          minorUnits: BigInt.from(1000123456789),
        );
        expect(ada.formatDecimal(), '1,000,123.456789');
      });

      test('toString returns money with currency code', () {
        final money = Money.fromMajorUnits(
          currency: Currencies.usdm,
          majorUnits: BigInt.from(123),
        );
        expect(money.toString(), r'$USDM 123.00');
      });
    });

    group('parse', () {
      test('parses USDM with symbol and decimals', () {
        final money = Money.parse(r'$10.99', Currencies.usdm);
        expect(money.minorUnits, BigInt.from(1099));
        expect(money.currency, Currencies.usdm);
      });

      test('parses USDM without decimals', () {
        final money = Money.parse('15', Currencies.usdm);
        expect(money.minorUnits, BigInt.from(1500));
        expect(money.currency, Currencies.usdm);
      });

      test('parses USDM with code instead of symbol', () {
        final money = Money.parse('USDM12.34', Currencies.usdm);
        expect(money.minorUnits, BigInt.from(1234));
        expect(money.currency, Currencies.usdm);
      });

      test('parses USDM with ticker instead of symbol', () {
        final money = Money.parse(r'$USDM12.34', Currencies.usdm);
        expect(money.minorUnits, BigInt.from(1234));
        expect(money.currency, Currencies.usdm);
      });

      test('parses USDM with ticker and whitespace instead of symbol', () {
        final money = Money.parse(r'$USDM 12.34', Currencies.usdm);
        expect(money.minorUnits, BigInt.from(1234));
        expect(money.currency, Currencies.usdm);
      });

      test('parses ADA with symbol and exact decimals', () {
        final money = Money.parse('₳0.123456', Currencies.ada);
        expect(money.minorUnits, BigInt.from(123456));
        expect(money.currency, Currencies.ada);
      });

      test('parses ADA with too many decimals (truncate)', () {
        final money = Money.parse('₳0.123456789', Currencies.ada);
        expect(money.minorUnits, BigInt.from(123456)); // truncated to 6 digits
        expect(money.currency, Currencies.ada);
      });

      test('parses ADA with fewer decimals (pad)', () {
        final money = Money.parse('₳2.5', Currencies.ada);
        // "2.5" => "2.500000" => 2,500,000
        expect(money.minorUnits, BigInt.from(2500000));
        expect(money.currency, Currencies.ada);
      });

      test('parses with whitespace and random formatting', () {
        final money = Money.parse(r'   $  99.5  ', Currencies.usdm);
        // => "9950" for USD
        expect(money.minorUnits, BigInt.from(9950));
        expect(money.currency, Currencies.usdm);
      });

      test('parses with comma thousands separator', () {
        final money = Money.parse(r'$1,23', Currencies.usdm);
        // "1.23" => 123 for USD
        expect(money.minorUnits, BigInt.from(12300));
        expect(money.currency, Currencies.usdm);
      });

      test('throws $FormatException if money is not given', () {
        expect(
          () => Money.parse(r'$', Currencies.usdm),
          throwsA(isA<FormatException>()),
        );
      });

      test('parses major-only ADA', () {
        final money = Money.parse('3', Currencies.ada);
        expect(money.minorUnits, BigInt.from(3000000));
        expect(money.currency, Currencies.ada);
      });

      test('parses with currency code and decimals', () {
        final money = Money.parse('ADA10.000001', Currencies.ada);
        expect(money.minorUnits, BigInt.from(10000001));
        expect(money.currency, Currencies.ada);
      });

      test('parses with currency ticker and decimals', () {
        final money = Money.parse(r'$ADA10.000001', Currencies.ada);
        expect(money.minorUnits, BigInt.from(10000001));
        expect(money.currency, Currencies.ada);
      });

      test('parses with currency ticker and decimals and whitespace', () {
        final money = Money.parse(r'$ADA 10.000001', Currencies.ada);
        expect(money.minorUnits, BigInt.from(10000001));
        expect(money.currency, Currencies.ada);
      });
    });
  });

  group('CoinExt', () {
    test('toMoney converts Coin to Money with ADA', () {
      const coin = Coin(123456789);
      final money = coin.toMoney();
      expect(money.currency, Currencies.ada);
      expect(money.minorUnits, BigInt.from(123456789));
    });
  });
}
