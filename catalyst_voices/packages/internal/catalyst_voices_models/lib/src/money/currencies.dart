import 'package:catalyst_voices_models/src/money/currency.dart';
import 'package:catalyst_voices_models/src/money/currency_code.dart';
import 'package:catalyst_voices_models/src/money/money.dart';

final class Currencies {
  /// Fallback currency for historical reasons.
  /// The first fund used a hardcoded currency, this constructors fallbacks to it.
  ///
  /// Needs to be synced with [MoneyUnits.fallback].
  static const fallback = ada;

  /// Predefined ADA currency (₳, 6 decimals).
  static const ada = Currency(
    code: CurrencyCode.ada,
    symbol: '₳',
    decimalDigits: 6,
    defaultPattern: '0.######',
    decimalPattern: '#,##0.######',
  );

  /// Predefined USDM currency ($, 2 decimals).
  static const usdm = Currency(
    code: CurrencyCode.usdm,
    symbol: r'$',
    decimalDigits: 2,
    defaultPattern: '0.00',
    decimalPattern: '#,##0.00',
  );

  /// A list of all currencies registered here.
  static const values = [ada, usdm];

  const Currencies._();
}
