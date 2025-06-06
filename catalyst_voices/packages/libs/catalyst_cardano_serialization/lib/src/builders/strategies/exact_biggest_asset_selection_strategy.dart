import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';

/// A coin selection strategy that prioritizes UTxOs without other assets.
///
/// If both UTxO have extra assets or both of them don't have any other assets
/// then the larger asset balance is prioritized.
final class ExactBiggestAssetSelectionStrategy implements CoinSelectionStrategy {
  /// Default const constructor for [ExactBiggestAssetSelectionStrategy]
  const ExactBiggestAssetSelectionStrategy();

  @override
  void apply(AssetsGroup assetsGroup) {
    for (final asset in assetsGroup) {
      asset.value.sort((a, b) => _tokenCompare(asset.key, a, b));
    }
  }

  bool _hasOtherAssets(Balance balance, AssetId assetId) {
    final assets = balance.listNonZeroAssetIds()..remove(assetId);
    return assets.isNotEmpty;
  }

  /// Compares this [TransactionUnspentOutput] with another
  /// [TransactionUnspentOutput].
  ///
  /// This method prioritizes UTxO which don't have other assets than [asset].
  /// If both UTxO have extra assets or both of them don't have any other assets
  /// then the larger [asset] balance is prioritized.
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

    final thisAssetBalance = thisBalance[asset] ?? const Coin(0);
    final otherAssetBalance = otherBalance[asset] ?? const Coin(0);

    final thisHasOtherAssets = _hasOtherAssets(thisBalance, asset);
    final otherHasOtherAssets = _hasOtherAssets(otherBalance, asset);

    if (!thisHasOtherAssets && otherHasOtherAssets) {
      return -1;
    } else if (thisHasOtherAssets && otherHasOtherAssets) {
      return 1;
    } else {
      return otherAssetBalance.compareTo(thisAssetBalance);
    }
  }
}
