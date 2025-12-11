import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class MoneyFormat extends Equatable {
  final Currency currency;
  final MoneyUnits moneyUnits;

  const MoneyFormat({
    required this.currency,
    required this.moneyUnits,
  });

  @override
  List<Object?> get props => [
    currency,
    moneyUnits,
  ];

  /// Parses the [MoneyFormat] from a [format].
  /// Returns `null` if format is unrecognized.
  ///
  /// Format:
  /// - token|fiat[:$brand]:$code[:$cent]
  ///
  /// Examples:
  /// - token:cardano:ada
  /// - token:cardano:ada:lovelace
  /// - token:usdm
  /// - token:usdm:cent
  /// - fiat:usd
  /// - fiat:usd:cent
  /// - fiat:eur
  /// - fiat:eur:cent
  static MoneyFormat? parse(String format) {
    final parts = format.split(':');
    return switch (parts) {
      [final type, _, final code, final minor]
          when _isValidType(type) && _isValidMinorUnits(minor) =>
        _createFormat(code, MoneyUnits.minorUnits),

      [final type, final code, final minor] when _isValidType(type) && _isValidMinorUnits(minor) =>
        _createFormat(code, MoneyUnits.minorUnits),

      [final type, _, final code] when _isValidType(type) => _createFormat(
        code,
        MoneyUnits.majorUnits,
      ),

      [final type, final code] when _isValidType(type) => _createFormat(
        code,
        MoneyUnits.majorUnits,
      ),
      _ => null,
    };
  }

  static MoneyFormat? _createFormat(
    String currencyCode,
    MoneyUnits moneyUnits,
  ) {
    final currency = Currency.fromCode(currencyCode);
    if (currency == null) {
      return null;
    }
    return MoneyFormat(
      currency: currency,
      moneyUnits: moneyUnits,
    );
  }

  /// Checks if a string identifies a minor currency unit.
  static bool _isValidMinorUnits(String minorUnits) {
    return switch (minorUnits) {
      'cent' || 'penny' || 'lovelace' || 'sat' || 'wei' => true,
      _ => false,
    };
  }

  /// Checks if the type is 'fiat' or 'token'.
  static bool _isValidType(String type) {
    return type == 'fiat' || type == 'token';
  }
}
