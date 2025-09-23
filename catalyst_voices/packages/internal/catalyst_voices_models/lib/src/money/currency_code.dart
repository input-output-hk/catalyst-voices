import 'package:equatable/equatable.dart';

/// A currency code.
///
/// For fiat currencies 3 uppercase letter code (ISO-4217).
///
/// For cryptocurrencies can be longer and usually doesn't represent
/// a valid ISO-4217 since cryptocurrencies aren't covered.
final class CurrencyCode extends Equatable {
  /// ADA cryptocurrency code.
  static const ada = CurrencyCode._('ADA');

  /// USD fiat currency code.
  static const usd = CurrencyCode._('USD');

  final String _code;

  /// Constructs a new [CurrencyCode], ensures that [code] is uppercase.
  CurrencyCode(String code) : this._(code.toUpperCase());

  /// Internal const constructor.
  const CurrencyCode._(String code) : _code = code;

  /// The iso code.
  String get code => _code;

  @override
  List<Object?> get props => [_code];

  @override
  String toString() => _code;
}
