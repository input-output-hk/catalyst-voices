import 'package:catalyst_voices_models/src/money/currency_code.dart';
import 'package:catalyst_voices_models/src/money/money.dart';
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
  }) : _map = map ?? {};

  /// Creates a [MultiCurrencyAmount] from a list of [Money] values.
  ///
  /// Example:
  /// ```dart
  /// final amounts = MultiCurrencyAmount.list([usdMoney, adaMoney]);
  /// ```
  factory MultiCurrencyAmount.list(List<Money> money) {
    final group = MultiCurrencyAmount();
    for (final item in money) {
      group.add(item);
    }
    return group;
  }

  /// Creates a [MultiCurrencyAmount] with a single [Money] value.
  ///
  /// Example:
  /// ```dart
  /// final amount = MultiCurrencyAmount.single(usdMoney);
  /// ```
  factory MultiCurrencyAmount.single(Money money) {
    final group = MultiCurrencyAmount()..add(money);
    return group;
  }

  /// Returns all [Money] values in this collection as a list.
  List<Money> get list => _map.values.toList();

  @override
  List<Object?> get props => [_map];

  /// Returns the [Money] value for the given [isoCode], or null if not present.
  Money? operator [](CurrencyCode isoCode) {
    return _map[isoCode];
  }

  /// Adds [money] to the collection.
  ///
  /// If an amount for the same currency already exists, it sums them.
  /// Zero amounts are automatically removed from the collection.
  void add(Money money) {
    final currency = money.currency;
    final current = _map[currency.isoCode];
    final updated = (current ?? Money.zero(currency: currency)) + money;
    _updateMap(updated);
  }

  /// Creates a deep copy of this [MultiCurrencyAmount].
  ///
  /// Modifications to the copy will not affect the original.
  MultiCurrencyAmount deepCopy() {
    return MultiCurrencyAmount(map: Map.of(_map));
  }

  /// Subtracts [money] from the collection.
  ///
  /// If an amount for the same currency exists, it subtracts it.
  /// Zero amounts are automatically removed from the collection.
  void subtract(Money money) {
    final currency = money.currency;
    final current = _map[currency.isoCode];
    final updated = (current ?? Money.zero(currency: currency)) - money;
    _updateMap(updated);
  }

  /// Updates the internal map with [money].
  ///
  /// If the amount is zero, the entry is removed. Otherwise, it is added/updated.
  void _updateMap(Money money) {
    final isoCode = money.currency.isoCode;
    if (money.isZero) {
      _map.remove(isoCode);
    } else {
      _map[isoCode] = money;
    }
  }
}
