import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

/// Represents the valid range for coin values as a tuple of minimum and
/// maximum [Coin] values.
typedef ValidRange = (Coin, Coin);

/// Represents an asset identified by a [PolicyId] and [AssetName].
typedef AssetId = (PolicyId, AssetName);

/// Maps assets to UTxOs, where assets are identified by [PolicyId] and
/// [AssetName].
typedef AssetsMap = Map<AssetId, List<TransactionUnspentOutput>>;

/// A list of asset group entries, each mapping an asset to its associated
/// UTxOs.
typedef AssetsGroup = List<MapEntry<AssetId, List<TransactionUnspentOutput>>>;

/// Result of coin selection: selected inputs, change outputs, and transaction
/// fee.
typedef SelectionResult = (
  Set<TransactionUnspentOutput>,
  List<TransactionOutput>,
  Coin,
);

/// Interface for coin selection strategies applied to token maps.
// ignore: one_member_abstracts
abstract class CoinSelectionStrategy {
  /// Apply the coin selection strategy to the UTxOs in the given [assetsGroup].
  ///
  /// - [assetsGroup]: Maps assets to UTxOs, to be prioritised by the strategy.
  void apply(AssetsGroup assetsGroup);
}

/// Interface for coin selection algorithms for transactions.
///
/// Coin selection is the process of choosing UTxOs as inputs to fulfill the
/// transaction's outputs, while also calculating necessary change.
abstract interface class CoinSelector {
  /// The predefined [PolicyId] for ADA.
  static PolicyId adaPolicy = PolicyId('');

  /// The predefined [AssetName] for ADA.
  static final AssetName adaAssetName = AssetName('');

  /// The predefined [AssetId] for ADA.
  static final AssetId adaAssetId = (adaPolicy, adaAssetName);

  /// The valid range for coin values.
  ///
  /// The maximum value for coins is `2^53 - 1`, which fits the requirement as
  /// the maximum amount of Lovelaces cannot exceed `4.5 * 10^15`.
  static const ValidRange coinValueRange = (Coin(0), Coin(2 ^ 53 - 1));

  /// The valid range for asset values.
  ///
  /// The maximum minting amount for any asset is `±2^63`, while the amount
  /// that can be stored in any output is `2^64`.
  static const ValidRange assetValueRange = (Coin(1), Coin(2 ^ 64));

  /// The maximum number of inputs that can be used for coin selection.
  ///
  /// This constant defines the upper limit on the number of UTxOs that can be
  /// selected for inclusion in a transaction. It defaults to 500.
  ///
  /// If needed, this value can be adjusted depending on the specific use case.
  static const maxInputs = 500;

  /// The minimum number of inputs that must be selected for coin selection.
  ///
  /// This constant defines the lower limit on the number of UTxOs
  /// that must be selected for inclusion in a transaction. It defaults to 0.
  ///
  ///
  static const minInputs = 0;

  /// Selects UTxOs to fulfill the required outputs and calculates change.
  ///
  /// - [builder]: The transaction builder containing available UTxOs and
  ///   desired outputs.
  /// - [minInputs]: Minimum inputs required.
  /// - [maxInputs]: Maximum allowed inputs.
  ///
  /// Returns:
  /// - [SelectionResult] with selected inputs, change outputs, and transaction
  ///   fee.
  ///
  /// Throws:
  /// - An exception if constraints cannot be satisfied.
  SelectionResult? selectInputs({
    required TransactionBuilder builder,
    int minInputs = CoinSelector.minInputs,
    int maxInputs = CoinSelector.maxInputs,
  });

  /// Groups UTxOs by assets, mapping each asset to its corresponding UTxOs for
  /// further processing by a coin selection strategy.
  ///
  /// This allows various implementations to group native tokens as needed,
  /// or group all UTxOs under the ADA asset. These asset groups can then be
  /// processed by the coin selection algorithm.
  ///
  /// - [requiredBalance]: The balance needed to satisfy the transaction.
  /// - [inputs]: A set of available UTxOs for selection.
  ///
  /// Returns:
  /// - An [AssetsGroup] where each entry maps an asset to its corresponding
  ///   UTxOs.
  AssetsGroup buildAssetGroups(
    Balance requiredBalance,
    Set<TransactionUnspentOutput> inputs,
  );

  /// A helper function to calculate the total balance from a collection of
  /// items.
  ///
  /// This function takes an iterable of items (`items`) and a callback
  /// (`getAmount`) that extracts the `Balance` from each item. It iterates
  /// through the collection, summing up the balances and returning the total.
  ///
  /// Example usage:
  /// ```dart
  ///   final inputTotal =
  ///      calculateTotal(builder.inputs, (input) => input.output.amount);
  ///  final targetTotal =
  ///      calculateTotal(builder.outputs, (output) => output.amount);
  /// ```
  ///
  /// - `items`: The iterable collection to process.
  /// - `getAmount`: A function that maps each item in the collection to its
  ///    `Balance`.
  /// - Returns: The total `Balance` of the collection.
  static Balance sumAmounts<T>(
    Iterable<T> items,
    Balance Function(T) getAmount,
  ) {
    return items.fold<Balance>(
      const Balance.zero(),
      (sum, item) => sum + getAmount(item),
    );
  }
}

/// Extension on [Balance] to provide comparison methods.
///
/// This extension adds a `lessThan` method to the [Balance] class, enabling
/// comparisons between two [Balance] instances based on both coin amount and
/// multi-asset bundles.
///
/// A [Balance] is considered "less than" another if *either*:
///  - Its coin amount is strictly less than the other's coin amount, OR
///  - For every asset in the target [Balance]'s multi-asset bundle, the
///    quantity of that asset in this [Balance] is strictly less than the
///    quantity in the target [Balance] (treating missing assets as having a
///    quantity of zero).
///
extension ComparableBalance on Balance {
  /// Checks if this [Balance] is less than the [target] [Balance].
  ///
  /// This method compares the coin amounts and multi-asset bundles of the
  /// two [Balance] instances.
  ///
  /// Returns `true` if any of the amounts of this [Balance] is less than
  /// the [target] balance, and `false` otherwise.
  /// It handles non-existing asset's amount as `Coin(0)`.
  bool lessThan(Balance target) {
    if (coin < target.coin) {
      return true;
    } else if (target.multiAsset != null) {
      for (final policy in target.multiAsset!.bundle.keys) {
        final assets = multiAsset?.bundle[policy] ?? {};
        final targetAssets = target.multiAsset!.bundle[policy]!;

        for (final assetName in targetAssets.keys) {
          final value = assets[assetName] ?? const Coin(0);
          final targetValue = targetAssets[assetName]!;

          if (value < targetValue) return true;
        }
      }
    }
    return false;
  }
}
