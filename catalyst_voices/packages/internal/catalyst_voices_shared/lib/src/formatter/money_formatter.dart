import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:intl/intl.dart';

/// Description of how to decorate a monetary amount during formatting.
enum MoneyDecoration {
  /// The amount is decorated with the currency symbol, i.e. $amount.
  symbol,

  /// The amount is decorated with the currency iso code (ticker), i.e. $USD amount.
  code,

  /// The amount is not decorated.
  none,
}

/// Formats [Money].
abstract class MoneyFormatter {
  static const _million = 1000000;
  static const _thousand = 1000;

  /// Decorates the formatted [amount] with corresponding [decoration].
  ///
  /// See [MoneyDecoration] for examples.
  static String decorate({
    required String amount,
    required MoneyDecoration decoration,
    required Currency currency,
  }) {
    switch (decoration) {
      case MoneyDecoration.symbol:
        return '${currency.symbol}$amount';
      case MoneyDecoration.code:
        return '\$${currency.isoCode.code} $amount';
      case MoneyDecoration.none:
        return amount;
    }
  }

  /// Formats the [money] amount in a compact way.
  /// The amount is rounded up to two most significant decimals.
  ///
  /// Uses K (thousands) or M (millions) multipliers.
  /// The currency symbol will come from [money] currency.
  ///
  /// Examples (vary on [decoration]):
  /// - ₳123 = ₳123
  /// - ₳123.456 = ₳123.46
  /// - ₳123.000456 = ₳123
  /// - ₳1000 = ₳1K
  /// - ₳1000000 = ₳1M
  /// - ₳1230000 = ₳1.23M
  /// - ₳1000123.456 = ₳1M
  static String formatCompactRounded(
    Money money, {
    MoneyDecoration decoration = MoneyDecoration.symbol,
  }) {
    final numberFormat = NumberFormat('#.##');
    final decimalAmount = money.minorUnits / BigInt.from(pow(10, money.currency.decimalDigits));

    final String formatted;
    if (decimalAmount >= _million) {
      final millions = decimalAmount / _million;
      formatted = '${numberFormat.format(millions)}M';
    } else if (decimalAmount >= _thousand) {
      final thousands = decimalAmount / _thousand;
      formatted = '${numberFormat.format(thousands)}K';
    } else {
      formatted = numberFormat.format(decimalAmount);
    }

    return decorate(
      amount: formatted,
      decoration: decoration,
      currency: money.currency,
    );
  }

  /// Formats the [money] amount in a decimal way with separators.
  ///
  /// The currency symbol will come from [money] currency.
  ///
  /// Examples (ADA):
  /// - ₳123 = ₳123
  /// - ₳123.456 = ₳123.456
  /// - ₳123.000456 = ₳123.000456
  /// - ₳1000 = ₳1,000
  /// - ₳1000000 = ₳1,000,000
  /// - ₳1000123.456789 = ₳1,000,123.456789
  ///
  /// Examples (USD):
  /// - $123 = $123
  /// - $123.45 = $123.45
  /// - $1000123.45 = $1,000,123.45
  static String formatDecimal(Money money, {MoneyDecoration decoration = MoneyDecoration.symbol}) {
    final String formatted;
    if (money.minorUnits == BigInt.zero) {
      formatted = '-';
    } else {
      formatted = money.formatDecimal();
    }

    return decorate(
      amount: formatted,
      decoration: decoration,
      currency: money.currency,
    );
  }

  /// Formats the exact [money] amount to the tiniest minor unit (cent/lovelace) precision.
  /// Similar to [formatDecimal] but doesn't use group separators.
  ///
  /// The currency symbol will come from [money] currency.
  ///
  /// Examples (ADA):
  /// - ₳123 = ₳123
  /// - ₳123.456 = ₳123.456
  /// - ₳123.000456 = ₳123.000456
  /// - ₳1000 = ₳1000
  /// - ₳1000000 = ₳1000000
  /// - ₳1000123.456789 = ₳1000123.456789
  ///
  /// Examples (USD):
  /// - $123 = $123
  /// - $123.45 = $123.45
  /// - $1000123.45 = $1000123.45
  static String formatExactAmount(
    Money money, {
    MoneyDecoration decoration = MoneyDecoration.symbol,
  }) {
    return decorate(
      amount: money.format(),
      decoration: decoration,
      currency: money.currency,
    );
  }
}
