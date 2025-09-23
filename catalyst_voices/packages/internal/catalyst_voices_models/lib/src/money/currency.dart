import 'package:catalyst_voices_models/src/money/currency_code.dart';
import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart' as money2;

/// Represents a currency with ISO code, symbol, decimal precision,
/// and formatting patterns.
///
/// Provides factory constructors for common currencies
/// like ADA and USD, as well as helpers to format amounts.
final class Currency extends Equatable {
  /// The ISO 4217 code of the currency (e.g., ADA, USD).
  final CurrencyCode isoCode;

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
    required this.isoCode,
    required this.symbol,
    required this.decimalDigits,
    required this.defaultPattern,
    required this.decimalPattern,
  });

  /// Predefined ADA currency (₳, 6 decimals).
  const Currency.ada()
    : this(
        isoCode: CurrencyCode.ada,
        symbol: '₳',
        decimalDigits: 6,
        defaultPattern: '0.######',
        decimalPattern: '#,##0.######',
      );

  /// Fallback currency for historical reasons.
  /// The first fund used a hardcoded currency, this constructors fallbacks to it.
  const Currency.fallback() : this.ada();

  /// Predefined USD currency ($, 2 decimals).
  const Currency.usd()
    : this(
        isoCode: CurrencyCode.usd,
        symbol: r'$',
        decimalDigits: 2,
        defaultPattern: '0.00',
        decimalPattern: '#,##0.00',
      );

  @override
  List<Object?> get props => [
    isoCode,
    symbol,
  ];

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
      isoCode.code,
      decimalDigits,
      pattern: defaultPattern,
      symbol: symbol,
    );
  }
}

