import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';
import 'package:cbor/cbor.dart';

/// A greedy selection strategy that prioritizes UTXOs with fewer multi-assets
/// to minimize transaction complexity and fees.
class GreedySelectionStrategy implements CoinSelectionStrategy {
  /// Default const constructor for [GreedySelectionStrategy]
  const GreedySelectionStrategy();

  @override
  void apply(AssetsGroup assetGroups) {
    for (final entry in assetGroups) {
      final asset = entry.key;
      final utxos = entry.value;

      // Sort UTXOs by complexity
      utxos.sort((a, b) => _compareUtxosForEfficiency(a, b, asset));
    }
  }
}

/// Select best UTXOs
/// 1. UTXOs with fewer multi-assets
/// 2. Smaller size
/// 3. Asset amount for the specific asset required
int _compareUtxosForEfficiency(
  TransactionUnspentOutput thisUtxo,
  TransactionUnspentOutput otherUtxo,
  AssetId asset,
) {
  final thisBalance = thisUtxo.output.amount;
  final otherBalance = otherUtxo.output.amount;

  // Prioritise UTXOs with fewer multi-assets to reduce change complexity
  final thisAssetCount =
      thisBalance.multiAsset?.bundle.values.fold<int>(0, (sum, assets) => sum + assets.length) ?? 0;
  final otherAssetCount =
      otherBalance.multiAsset?.bundle.values.fold<int>(0, (sum, assets) => sum + assets.length) ??
          0;

  // Prefer UTXOs with fewer assets
  if (thisAssetCount != otherAssetCount) {
    return thisAssetCount.compareTo(otherAssetCount);
  }

  // For ADA use larger amounts to minimize input count
  if (asset == CoinSelector.adaAssetId) {
    final thisAda = thisBalance.coin;
    final otherAda = otherBalance.coin;

    if (thisAda != otherAda) {
      return otherAda.compareTo(thisAda);
    }
  }

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

  return thisAssetBalance.compareTo(otherAssetBalance);
}
