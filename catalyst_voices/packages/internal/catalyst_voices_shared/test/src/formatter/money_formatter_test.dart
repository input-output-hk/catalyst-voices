import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/src/formatter/money_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(MoneyFormatter, () {
    group('formatCompactRounded', () {
      test('₳123 = ₳123', () {
        final money = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(123),
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 123');
      });

      test('₳123.456 = ₳123.46', () {
        final money = Money(
          currency: Currencies.ada,
          minorUnits: BigInt.from(123456000), // 123.456
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 123.46');
      });

      test('₳123.000456 = ₳123', () {
        final money = Money(
          currency: Currencies.ada,
          minorUnits: BigInt.from(123000456),
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 123');
      });

      test('₳1000 = ₳1K', () {
        final money = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(1000),
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 1K');
      });

      test('₳1000000 = ₳1M', () {
        final money = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(1000000),
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 1M');
      });

      test('₳1230000 = ₳1.23M', () {
        final money = Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(1230000),
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 1.23M');
      });

      test('₳1000123.456 = ₳1M', () {
        final money = Money(
          currency: Currencies.ada,
          minorUnits: BigInt.from(1000123456000), // 1000123.456
        );
        expect(MoneyFormatter.formatCompactRounded(money), r'$ADA 1M');
      });
    });

    group('formatDecimal', () {
      group('ADA', () {
        test('₳123 = ₳123', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.ada,
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$ADA 123');
        });

        test('₳123.456 = ₳123.456', () {
          final money = Money(
            currency: Currencies.ada,
            minorUnits: BigInt.from(123456000),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$ADA 123.456');
        });

        test('₳123.000456 = ₳123.000456', () {
          final money = Money(
            currency: Currencies.ada,
            minorUnits: BigInt.from(123000456),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$ADA 123.000456');
        });

        test('₳1000 = ₳1,000', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.ada,
            majorUnits: BigInt.from(1000),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$ADA 1,000');
        });

        test('₳1000000 = ₳1,000,000', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.ada,
            majorUnits: BigInt.from(1000000),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$ADA 1,000,000');
        });

        test('₳1000123.456789 = ₳1,000,123.456789', () {
          final money = Money(
            currency: Currencies.ada,
            minorUnits: BigInt.from(1000123456789),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$ADA 1,000,123.456789');
        });
      });

      group('USD', () {
        test(r'$123 = $123', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.usdm,
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$USDM 123.00');
        });

        test(r'$123.45 = $123.45', () {
          final money = Money(
            currency: Currencies.usdm,
            minorUnits: BigInt.from(12345),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$USDM 123.45');
        });

        test(r'$1000123.45 = $1,000,123.45', () {
          final money = Money(
            currency: Currencies.usdm,
            minorUnits: BigInt.from(100012345),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$USDM 1,000,123.45');
        });
      });
    });

    group('formatExactAmount', () {
      group('ADA', () {
        test('₳123 = ₳123', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.ada,
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$ADA 123');
        });

        test('₳123.456 = ₳123.456', () {
          final money = Money(
            currency: Currencies.ada,
            minorUnits: BigInt.from(123456000),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$ADA 123.456');
        });

        test('₳123.000456 = ₳123.000456', () {
          final money = Money(
            currency: Currencies.ada,
            minorUnits: BigInt.from(123000456),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$ADA 123.000456');
        });

        test('₳1000 = ₳1000', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.ada,
            majorUnits: BigInt.from(1000),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$ADA 1000');
        });

        test('₳1000000 = ₳1000000', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.ada,
            majorUnits: BigInt.from(1000000),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$ADA 1000000');
        });

        test('₳1000123.456789 = ₳1000123.456789', () {
          final money = Money(
            currency: Currencies.ada,
            minorUnits: BigInt.from(1000123456789),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$ADA 1000123.456789');
        });
      });

      group('USD', () {
        test(r'$123 = $123', () {
          final money = Money.fromMajorUnits(
            currency: Currencies.usdm,
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$USDM 123.00');
        });

        test(r'$123.45 = $123.45', () {
          final money = Money(
            currency: Currencies.usdm,
            minorUnits: BigInt.from(12345),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$USDM 123.45');
        });

        test(r'$1000123.45 = $1000123.45', () {
          final money = Money(
            currency: Currencies.usdm,
            minorUnits: BigInt.from(100012345),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$USDM 1000123.45');
        });
      });
    });

    group('decorate', () {
      test(MoneyDecoration.symbol, () {
        final formatted = MoneyFormatter.decorate(
          amount: '100.00',
          decoration: MoneyDecoration.symbol,
          currency: Currencies.usdm,
        );

        expect(formatted, equals(r'$100.00'));
      });

      test('${MoneyDecoration.code} - ADA', () {
        final formatted = MoneyFormatter.decorate(
          amount: '100.00',
          decoration: MoneyDecoration.code,
          currency: Currencies.ada,
        );

        expect(formatted, equals(r'$ADA 100.00'));
      });

      test('${MoneyDecoration.code} - USDM', () {
        final formatted = MoneyFormatter.decorate(
          amount: '100.00',
          decoration: MoneyDecoration.code,
          currency: Currencies.usdm,
        );

        expect(formatted, equals(r'$USDM 100.00'));
      });

      test('${MoneyDecoration.code} - fiat (USD)', () {
        final formatted = MoneyFormatter.decorate(
          amount: '100.00',
          decoration: MoneyDecoration.code,
          currency: Currency.fromCode('USD')!,
        );

        expect(formatted, equals('USD 100.00'));
      });

      test('${MoneyDecoration.code} - fiat (EUR)', () {
        final formatted = MoneyFormatter.decorate(
          amount: '100.00',
          decoration: MoneyDecoration.code,
          currency: Currency.fromCode('EUR')!,
        );

        expect(formatted, equals('EUR 100.00'));
      });

      test('${MoneyDecoration.code} - fiat (JPY)', () {
        final formatted = MoneyFormatter.decorate(
          amount: '100',
          decoration: MoneyDecoration.code,
          currency: Currency.fromCode('JPY')!,
        );

        expect(formatted, equals('JPY 100'));
      });

      test(MoneyDecoration.none, () {
        final formatted = MoneyFormatter.decorate(
          amount: '100.00',
          decoration: MoneyDecoration.none,
          currency: Currencies.usdm,
        );

        expect(formatted, equals('100.00'));
      });
    });
  });
}
