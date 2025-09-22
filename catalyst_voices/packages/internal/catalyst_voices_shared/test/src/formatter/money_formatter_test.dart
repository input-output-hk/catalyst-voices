import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/src/formatter/money_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(MoneyFormatter, () {
    group('formatCompactRounded', () {
      group('includeSymbol = true', () {
        test('₳123 = ₳123', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳123');
        });

        test('₳123.456 = ₳123.46', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123456000), // 123.456
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳123.46');
        });

        test('₳123.000456 = ₳123', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123000456),
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳123');
        });

        test('₳1000 = ₳1K', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000),
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳1K');
        });

        test('₳1000000 = ₳1M', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000000),
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳1M');
        });

        test('₳1230000 = ₳1.23M', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1230000),
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳1.23M');
        });

        test('₳1000123.456 = ₳1M', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(1000123456000), // 1000123.456
          );
          expect(MoneyFormatter.formatCompactRounded(money), '₳1M');
        });
      });

      group('includeSymbol = false', () {
        test('₳123 = 123', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(123),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '123',
          );
        });

        test('₳123.456 = 123.46', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123456000),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '123.46',
          );
        });

        test('₳123.000456 = 123', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123000456),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '123',
          );
        });

        test('₳1000 = 1K', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '1K',
          );
        });

        test('₳1000000 = 1M', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000000),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '1M',
          );
        });

        test('₳1230000 = 1.23M', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1230000),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '1.23M',
          );
        });

        test('₳1000123.456 = 1M', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(1000123456000),
          );
          expect(
            MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
            '1M',
          );
        });
      });
    });

    group('formatDecimal', () {
      group('ADA', () {
        test('₳123 = ₳123', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatDecimal(money), '₳123');
        });

        test('₳123.456 = ₳123.456', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123456000),
          );
          expect(MoneyFormatter.formatDecimal(money), '₳123.456');
        });

        test('₳123.000456 = ₳123.000456', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123000456),
          );
          expect(MoneyFormatter.formatDecimal(money), '₳123.000456');
        });

        test('₳1000 = ₳1,000', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000),
          );
          expect(MoneyFormatter.formatDecimal(money), '₳1,000');
        });

        test('₳1000000 = ₳1,000,000', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000000),
          );
          expect(MoneyFormatter.formatDecimal(money), '₳1,000,000');
        });

        test('₳1000123.456789 = ₳1,000,123.456789', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(1000123456789),
          );
          expect(MoneyFormatter.formatDecimal(money), '₳1,000,123.456789');
        });
      });

      group('USD', () {
        test(r'$123 = $123', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.usd(),
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$123.00');
        });

        test(r'$123.45 = $123.45', () {
          final money = Money(
            currency: const Currency.usd(),
            minorUnits: BigInt.from(12345),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$123.45');
        });

        test(r'$1000123.45 = $1,000,123.45', () {
          final money = Money(
            currency: const Currency.usd(),
            minorUnits: BigInt.from(100012345),
          );
          expect(MoneyFormatter.formatDecimal(money), r'$1,000,123.45');
        });
      });
    });

    group('formatExactAmount', () {
      group('ADA', () {
        test('₳123 = ₳123', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatExactAmount(money), '₳123');
        });

        test('₳123.456 = ₳123.456', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123456000),
          );
          expect(MoneyFormatter.formatExactAmount(money), '₳123.456');
        });

        test('₳123.000456 = ₳123.000456', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(123000456),
          );
          expect(MoneyFormatter.formatExactAmount(money), '₳123.000456');
        });

        test('₳1000 = ₳1000', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000),
          );
          expect(MoneyFormatter.formatExactAmount(money), '₳1000');
        });

        test('₳1000000 = ₳1000000', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.ada(),
            majorUnits: BigInt.from(1000000),
          );
          expect(MoneyFormatter.formatExactAmount(money), '₳1000000');
        });

        test('₳1000123.456789 = ₳1000123.456789', () {
          final money = Money(
            currency: const Currency.ada(),
            minorUnits: BigInt.from(1000123456789),
          );
          expect(MoneyFormatter.formatExactAmount(money), '₳1000123.456789');
        });
      });

      group('USD', () {
        test(r'$123 = $123', () {
          final money = Money.fromMajorUnits(
            currency: const Currency.usd(),
            majorUnits: BigInt.from(123),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$123.00');
        });

        test(r'$123.45 = $123.45', () {
          final money = Money(
            currency: const Currency.usd(),
            minorUnits: BigInt.from(12345),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$123.45');
        });

        test(r'$1000123.45 = $1000123.45', () {
          final money = Money(
            currency: const Currency.usd(),
            minorUnits: BigInt.from(100012345),
          );
          expect(MoneyFormatter.formatExactAmount(money), r'$1000123.45');
        });
      });
    });
  });
}
