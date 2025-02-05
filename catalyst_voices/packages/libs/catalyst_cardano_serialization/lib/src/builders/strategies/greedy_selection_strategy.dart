import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';
import 'package:cbor/cbor.dart';

/// A greedy selection strategy that selects UTxOs by length and value.
final class GreedySelectionStrategy implements CoinSelectionStrategy {
  /// Default const constructor for [GreedySelectionStrategy]
  const GreedySelectionStrategy();

  @override
  void apply(AssetsGroup assetsGroup) {
    for (final asset in assetsGroup) {
      asset.value.sort((a, b) => tokenCompare(asset.key, a, b));
    }
  }

  /// Compares this [TransactionUnspentOutput] with another
  /// [TransactionUnspentOutput].
  ///
  /// This method compares the UTxOs based on:
  /// 1. The length of the UTxO's balance.
  /// 2. The value of the UTxO.
  ///
  /// Parameters:
  /// - [asset]: The asset key to compare against.
  /// - [thisUtxo]: The first [TransactionUnspentOutput] to compare.
  /// - [otherUtxo]: The second [TransactionUnspentOutput] to compare.
  ///
  /// Returns:
  /// A negative integer, zero, or a positive integer as this UTxO is less than,
  /// equal to, or greater than the specified UTxO.
  int tokenCompare(
    AssetId asset,
    TransactionUnspentOutput thisUtxo,
    TransactionUnspentOutput otherUtxo,
  ) {
    final thisBalance = thisUtxo.output.amount;
    final otherBalance = otherUtxo.output.amount;

    final thisBalanceLength = cbor.encode(thisBalance.toCbor()).length;
    final otherBalanceLength = cbor.encode(otherBalance.toCbor()).length;

    if (thisBalanceLength != otherBalanceLength) {
      return thisBalanceLength.compareTo(otherBalanceLength);
    }

    final (pid, assetName) = asset;

    final thisAssetBalance = (asset == CoinSelector.adaAssetId)
        ? thisBalance.coin
        : thisBalance.multiAsset?.bundle[pid]?[assetName] ?? const Coin(0);
    final otherAssetBalance = (asset == CoinSelector.adaAssetId)
        ? otherBalance.coin
        : otherBalance.multiAsset?.bundle[pid]?[assetName] ?? const Coin(0);

    return (thisAssetBalance as int).compareTo(otherAssetBalance as int);
  }
}
