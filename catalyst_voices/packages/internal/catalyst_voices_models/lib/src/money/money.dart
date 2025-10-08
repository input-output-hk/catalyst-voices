import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/money/currencies.dart';
import 'package:catalyst_voices_models/src/money/currency.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Represents a monetary amount with a specific [Currency].
///
/// Stores the amount in [minorUnits] (e.g., cents, lovelace)
/// and provides arithmetic operations, comparisons, and
/// formatting utilities.
final class Money extends Equatable implements Comparable<Money> {
  /// The currency this money amount is denominated in.
  final Currency currency;

  /// The amount expressed in minor units (e.g., cents for USD,
  /// lovelace for ADA).
  final BigInt minorUnits;

  /// Creates a [Money] instance from [minorUnits] in the given [currency].
  const Money({
    required this.currency,
    required this.minorUnits,
  });

  /// Creates a [Money] amount from [majorUnits].
  ///
  /// Multiplies [majorUnits] by the currency's decimal precision
  /// to calculate [minorUnits].
  ///
  /// Example (USD, 2 decimals): `majorUnits = 123` → `$123.00`
  /// Example (ADA, 6 decimals): `majorUnits = 123` → `₳123.000000`
  factory Money.fromMajorUnits({
    required Currency currency,
    required BigInt majorUnits,
  }) {
    return Money(
      currency: currency,
      minorUnits: majorUnits * currency.decimalDigitsFactor,
    );
  }

  /// Creates a [Money] amount from [amount], either major or minor units specified by the [moneyUnits].
  factory Money.fromUnits({
    required Currency currency,
    required BigInt amount,
    required MoneyUnits moneyUnits,
  }) {
    switch (moneyUnits) {
      case MoneyUnits.majorUnits:
        return Money.fromMajorUnits(
          currency: currency,
          majorUnits: amount,
        );
      case MoneyUnits.minorUnits:
        return Money(
          currency: currency,
          minorUnits: amount,
        );
    }
  }

  /// Parses [Money] from a [string] using a [currency].
  ///
  /// Examples:
  /// - Money.parse('$10.99', usdm) -> Money(BigInt.from(1099), usdm)
  /// - Money.parse('₳0.123456', ada) -> Money(BigInt.from(123456), ada)
  /// - Money.parse('₳0.123456789', ada) -> Money(BigInt.from(123456), ada)
  factory Money.parse(String string, Currency currency) {
    final normalized = string
        .replaceAll(currency.symbol, '')
        .replaceAll(currency.code.value, '')
        .replaceAll(r'$', '')
        .replaceAll(' ', '')
        .removeThousandsSeparator()
        .normalizeDecimalSeparator();

    if (normalized.contains(NumberUtils.decimalSeparator)) {
      final parts = normalized.split(NumberUtils.decimalSeparator);
      final majorUnits = parts[0];
      var minorUnits = parts[1];

      if (minorUnits.length < currency.decimalDigits) {
        minorUnits = minorUnits.padRight(currency.decimalDigits, '0');
      } else if (minorUnits.length > currency.decimalDigits) {
        minorUnits = minorUnits.substring(0, currency.decimalDigits);
      }

      return Money(
        currency: currency,
        minorUnits: BigInt.parse(majorUnits + minorUnits),
      );
    } else {
      return Money(
        currency: currency,
        minorUnits: BigInt.parse(normalized) * currency.decimalDigitsFactor,
      );
    }
  }

  /// Creates a zero-amount [Money] instance for the given [currency].
  factory Money.zero({required Currency currency}) {
    return Money(currency: currency, minorUnits: BigInt.zero);
  }

  /// Returns `true` if the amount is equal to zero.
  bool get isZero => minorUnits == BigInt.zero;

  /// Returns the major units calculated from [minorUnits].
  /// If the [minorUnits] contains "cents" they will be truncated.
  BigInt get majorUnits => minorUnits ~/ currency.decimalDigitsFactor;

  @override
  List<Object?> get props => [currency, minorUnits];

  /// Adds [other] to this amount and returns a new [Money].
  ///
  /// Throws [ArgumentError] if the currencies differ.
  Money operator +(Money other) {
    _ensureCurrenciesSame(this, other);
    return Money(
      currency: currency,
      minorUnits: minorUnits + other.minorUnits,
    );
  }

  /// Subtracts [other] from this amount and returns a new [Money].
  ///
  /// Throws [ArgumentError] if the currencies differ.
  Money operator -(Money other) {
    _ensureCurrenciesSame(this, other);
    return Money(
      currency: currency,
      minorUnits: minorUnits - other.minorUnits,
    );
  }

  /// Returns `true` if this amount is strictly smaller than [other].
  bool operator <(Money other) => minorUnits < other.minorUnits;

  /// Returns `true` if this amount is smaller than or equal to [other].
  bool operator <=(Money other) => minorUnits < other.minorUnits || minorUnits == other.minorUnits;

  /// Returns `true` if this amount is strictly greater than [other].
  bool operator >(Money other) => minorUnits > other.minorUnits;

  /// Returns `true` if this amount is greater than or equal to [other].
  bool operator >=(Money other) => minorUnits > other.minorUnits || minorUnits == other.minorUnits;

  /// Compares this amount with [other] based on [minorUnits].
  ///
  /// Returns a negative number if smaller, zero if equal,
  /// or a positive number if greater.
  @override
  int compareTo(Money other) => minorUnits.compareTo(other.minorUnits);

  /// Formats the amount into a string using the currency's default pattern.
  ///
  /// Example (USD): `12345` → `123.45`
  /// Example (ADA): `123456000` → `123.456`
  String format() => currency.format(minorUnits);

  /// Formats the amount into a string using the currency's decimal pattern,
  /// including grouping separators.
  ///
  /// Example (USD): `100012345` → `1,000,123.45`
  /// Example (ADA): `1000123456789` → `1,000,123.456789`
  String formatDecimal() => currency.formatDecimal(minorUnits);

  /// Returns the formatted string representation of this amount with a currency symbol.
  @override
  String toString() => MoneyFormatter.formatExactAmount(this);

  /// Ensures both [Money] objects share the same [Currency].
  ///
  /// Throws [ArgumentError] if currencies differ.
  void _ensureCurrenciesSame(Money first, Money second) {
    final firstCurrency = first.currency.code;
    final secondCurrency = second.currency.code;
    if (firstCurrency != secondCurrency) {
      throw ArgumentError(
        'Detected currency mismatch, first: $firstCurrency, second: $secondCurrency',
      );
    }
  }
}

enum MoneyUnits {
  /// The monetary amount is entered in major units, i.e. whole dollars.
  majorUnits,

  /// The monetary amount is entered in minor units, i.e. cents.
  minorUnits;

  /// A historical money units, needs to be synced with [Currencies.fallback].
  static MoneyUnits get fallback => majorUnits;
}

/// Extension methods for [Coin] to interoperate with [Money].
extension CoinExt on Coin {
  /// Converts this [Coin] into a [Money] instance
  /// using ADA as the currency.
  Money toMoney() {
    return Money(
      currency: Currencies.ada,
      minorUnits: BigInt.from(value),
    );
  }
}
