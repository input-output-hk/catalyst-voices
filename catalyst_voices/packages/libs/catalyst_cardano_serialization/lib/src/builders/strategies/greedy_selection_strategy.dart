import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';
import 'package:cbor/cbor.dart';

/// A greedy selection strategy that selects UTxOs by length and value.
///
/// The algorithm prefers UTxOs which balance byte encoding is the largest.
final class GreedySelectionStrategy implements CoinSelectionStrategy {
  /// Default const constructor for [GreedySelectionStrategy]
  const GreedySelectionStrategy();

  @override
  void apply(AssetsGroup assetsGroup) {
    for (final asset in assetsGroup) {
      asset.value.sort((a, b) => _tokenCompare(asset.key, a, b));
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
  int _tokenCompare(
    AssetId asset,
    TransactionUnspentOutput thisUtxo,
    TransactionUnspentOutput otherUtxo,
  ) {
    final thisBalance = thisUtxo.output.amount;
    final otherBalance = otherUtxo.output.amount;

    final thisBalanceLength = cbor.encode(thisBalance.toCbor()).length;
    final otherBalanceLength = cbor.encode(otherBalance.toCbor()).length;

    if (thisBalanceLength != otherBalanceLength) {
      return otherBalanceLength.compareTo(thisBalanceLength);
    }

    final thisAssetBalance = thisBalance[asset] ?? const Coin(0);
    final otherAssetBalance = otherBalance[asset] ?? const Coin(0);

    return otherAssetBalance.compareTo(thisAssetBalance);
  }
}
