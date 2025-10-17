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

  /// USDM cryptocurrency code.
  static const usdm = CurrencyCode._('USDM');

  final String _value;

  /// Constructs a new [CurrencyCode], ensures that [value] is uppercase.
  CurrencyCode(String value) : this._(value.toUpperCase());

  /// Internal const constructor.
  const CurrencyCode._(String value) : _value = value;

  @override
  List<Object?> get props => [_value];

  /// The iso code.
  String get value => _value;

  @override
  String toString() => _value;
}
