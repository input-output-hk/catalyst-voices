import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:intl/intl.dart';

// TODO(damian-molinski): Convert later using money2 package.
/// Formats amounts of ADA cryptocurrency.
abstract class CryptocurrencyFormatter {
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
    final symbol = const Currency.ada().symbol;
    final ada = amount.ada;
    if (ada >= _million) {
      final millions = ada / _million;
      return '$symbol${numberFormat.format(millions)}M';
    } else if (ada >= _thousand) {
      final thousands = ada / _thousand;
      return '$symbol${numberFormat.format(thousands)}K';
    } else {
      return symbol + numberFormat.format(ada);
    }
  }

  /// Formats the exact [amount] of ADA cryptocurrency
  /// to the latest cent (=1 lovelace precision).
  ///
  /// Examples:
  /// - ₳1000000 = 1000000₳
  /// - ₳1000000.123456 = 1000000.123456₳
  /// - ₳0.123 = 0.123₳
  static String formatExactAmount(Coin amount) {
    final numberFormat = NumberFormat('#.######');
    final symbol = const Currency.ada().symbol;
    return numberFormat.format(amount.ada) + symbol;
  }
}
