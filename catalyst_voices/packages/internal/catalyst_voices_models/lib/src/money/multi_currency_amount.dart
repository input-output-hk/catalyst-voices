import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/money/currency_code.dart';
import 'package:equatable/equatable.dart';

/// Represents a collection of monetary amounts in multiple currencies.
///
/// Internally stores a map of [CurrencyCode] to [Money] and provides
/// methods to add, subtract, and retrieve amounts. Automatically removes
/// zero amounts from the collection.
final class MultiCurrencyAmount extends Equatable {
  /// Internal map of currency ISO code to [Money] amounts.
  final Map<CurrencyCode, Money> _map;

  /// Creates an empty [MultiCurrencyAmount] or initializes with an optional map.
  MultiCurrencyAmount({
    Map<CurrencyCode, Money>? map,
  }) : _map = Map.unmodifiable(map ?? {});

  /// Creates a [MultiCurrencyAmount] from a list of [Money] values.
  ///
  /// Example:
  /// ```dart
  /// final amounts = MultiCurrencyAmount.list([usdmMoney, adaMoney]);
  /// ```
  factory MultiCurrencyAmount.list(List<Money> money) {
    final map = <CurrencyCode, Money>{};

    for (final item in money) {
      final currency = item.currency;

      map.update(
        currency.code,
        (value) => value + item,
        ifAbsent: () => item,
      );
    }

    map.removeWhere((key, value) => value.isZero);

    return MultiCurrencyAmount(map: map);
  }

  /// Creates a [MultiCurrencyAmount] with a single [Money] value.
  ///
  /// Example:
  /// ```dart
  /// final amount = MultiCurrencyAmount.single(usdmMoney);
  /// ```
  factory MultiCurrencyAmount.single(Money money) => MultiCurrencyAmount.list([money]);

  /// Creates a [MultiCurrencyAmount] with a single zero [Money] value.
  ///
  /// The currency defaults to [Currencies.fallback] if not specified.
  factory MultiCurrencyAmount.zero({
    Currency currency = Currencies.fallback,
  }) {
    return MultiCurrencyAmount.single(Money.zero(currency: currency));
  }

  /// Returns all [Money] values in this collection as a list.
  List<Money> get list => List.unmodifiable(_map.values);

  @override
  List<Object?> get props => [_map];

  /// Returns the [Money] value for the given [isoCode], or null if not present.
  Money? operator [](CurrencyCode isoCode) {
    return _map[isoCode];
  }

  /// Creates a deep copy of this [MultiCurrencyAmount].
  ///
  /// Modifications to the copy will not affect the original.
  MultiCurrencyAmount deepCopy() {
    return MultiCurrencyAmount(map: Map.of(_map));
  }

  @override
  String toString() => 'MultiCurrencyAmount(${_map.values.join(', ')})';
}
