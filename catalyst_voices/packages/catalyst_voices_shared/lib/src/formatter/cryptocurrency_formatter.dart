import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:intl/intl.dart';

/// Formats amounts of ADA cryptocurrency.
abstract class CryptocurrencyFormatter {
  static const adaSymbol = '₳';

  static const _million = 1000000;
  static const _thousand = 1000;

  /// Formats the [amount] of ADA cryptocurrency.
  ///
  /// Uses K (thousands) or M (millions) multipliers.
  /// Examples:
  /// - ₳123 = ₳123
  /// - ₳1000 = ₳1K
  /// - ₳1000000 = ₳1M
  static String formatAmount(Coin amount) {
    final numberFormat = NumberFormat('#.##');
    final ada = amount.ada;
    if (ada >= _million) {
      final millions = ada / _million;
      return '$adaSymbol${numberFormat.format(millions)}M';
    } else if (ada >= _thousand) {
      final thousands = ada / _thousand;
      return '$adaSymbol${numberFormat.format(thousands)}K';
    } else {
      return adaSymbol + numberFormat.format(ada);
    }
  }
}
