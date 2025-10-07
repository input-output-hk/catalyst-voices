import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/money/currency_code.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart' as money2;

/// Represents a currency with ISO code, symbol, decimal precision,
/// and formatting patterns.
///
/// Provides factory constructors for common currencies
/// like ADA and USD, as well as helpers to format amounts.
final class Currency extends Equatable {
  /// The ISO 4217 code of the currency (e.g. USD) or cryptocurrency ticker (e.g. ADA).
  final CurrencyCode code;

  /// The type of the currency.
  final CurrencyType type;

  /// The symbol used to represent the currency (e.g., ₳, $).
  final String symbol;

  /// Number of decimal digits supported by the currency.
  /// For example, ADA has 6, USD has 2.
  final int decimalDigits;

  /// Default formatting pattern used for display without grouping separators.
  /// Example: `S0.00` for USD, `S0.######` for ADA.
  final String defaultPattern;

  /// Decimal formatting pattern with grouping separators.
  /// Example: `S#,##0.00` for USD, `S#,##0.######` for ADA.
  final String decimalPattern;

  /// Creates a custom [Currency] with the provided properties.
  const Currency({
    required this.code,
    required this.type,
    required this.symbol,
    required this.decimalDigits,
    required this.defaultPattern,
    required this.decimalPattern,
  });

  /// The factor of 10 to divide a minor value by to get the intended
  /// currency value.
  ///
  ///  e.g. if [decimalDigits] is 2 then this value will be 100.
  BigInt get decimalDigitsFactor => BigInt.from(10).pow(decimalDigits);

  @override
  List<Object?> get props => [
    code,
    type,
    symbol,
    decimalDigits,
    defaultPattern,
    decimalPattern,
  ];

  /// Syntax sugar for [amountBig].
  Money amount(
    int value, {
    MoneyUnits moneyUnits = MoneyUnits.majorUnits,
  }) {
    return amountBig(
      BigInt.from(value),
      moneyUnits: moneyUnits,
    );
  }

  /// Creates [Money] instance with this [Currency].
  ///
  /// Because [Money] stores values always in minor units
  /// you have to tell if [value] is passed in minor or major
  /// units.
  ///
  /// Units:
  /// Ada == major unit
  /// lovelaces == minor unit.
  ///
  /// Examples
  /// Currencies.ada.amount(1)
  /// Currencies.ada.amount(1000000, moneyUnits: MoneyUnits.minorUnits)
  ///
  /// Gives same amount of money.
  Money amountBig(
    BigInt value, {
    MoneyUnits moneyUnits = MoneyUnits.majorUnits,
  }) {
    return Money.fromUnits(
      currency: this,
      amount: value,
      moneyUnits: moneyUnits,
    );
  }

  /// Formats [minorUnits] into a string using [defaultPattern].
  ///
  /// Example (USD): `12345` → `123.45`
  /// Example (ADA): `123456000` → `123.456`
  String format(BigInt minorUnits) {
    final currency = _createCurrency();
    final money = money2.Money.fromBigIntWithCurrency(minorUnits, currency);
    return money.format(defaultPattern);
  }

  /// Formats [minorUnits] into a string using [decimalPattern],
  /// with grouping separators.
  ///
  /// Example (USD): `100012345` → `1,000,123.45`
  /// Example (ADA): `1000123456789` → `1,000,123.456789`
  String formatDecimal(BigInt minorUnits) {
    final currency = _createCurrency();
    final money = money2.Money.fromBigIntWithCurrency(minorUnits, currency);
    return money.format(decimalPattern);
  }

  money2.Currency _createCurrency() {
    return money2.Currency.create(
      code.value,
      decimalDigits,
      pattern: defaultPattern,
      symbol: symbol,
    );
  }

  /// Lookups the currency by [code].
  static Currency? fromCode(String? code) {
    if (code == null) {
      return null;
    }

    return _lookupCustomCurrencies(code) ?? _lookupCurrencyByIsoCode(code);
  }

  /// Builds a default [decimalPattern].
  static String _buildDefaultDecimalPattern(int decimalDigits) {
    if (decimalDigits == 0) {
      return '#,##0';
    } else {
      return '#,##0.${'0' * decimalDigits}';
    }
  }

  /// Builds a default [defaultPattern].
  static String _buildDefaultPattern(int decimalDigits) {
    if (decimalDigits == 0) {
      return '0';
    } else {
      return '0.${'0' * decimalDigits}';
    }
  }

  static Currency? _lookupCurrencyByIsoCode(String code) {
    final currency = money2.Currencies().find(code.toUpperCase());
    if (currency == null) {
      return null;
    }

    return Currency(
      code: CurrencyCode(currency.isoCode),
      type: CurrencyType.fiat,
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
      defaultPattern: _buildDefaultPattern(currency.decimalDigits),
      decimalPattern: _buildDefaultDecimalPattern(currency.decimalDigits),
    );
  }

  static Currency? _lookupCustomCurrencies(String code) {
    return Currencies.values.firstWhereOrNull(
      (e) => e.code.value.equalsIgnoreCase(code),
    );
  }
}

enum CurrencyType {
  /// A currency is a traditional (fiat) money.
  fiat,

  /// A currency is a digital cryptocurrency.
  crypto,
}
