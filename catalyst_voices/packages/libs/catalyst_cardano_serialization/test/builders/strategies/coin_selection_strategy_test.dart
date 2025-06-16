import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data.dart';

void main() {
  group(ExactBiggestAssetSelectionStrategy, () {
    test('assets are sorted from largest-ada only to smallest-with-native-assets', () {
      final assetsGroup = [
        MapEntry(
          CoinSelector.adaAssetId,
          [
            _smallNativeAssetsUtxo(),
            _smallAdaOnlyUtxo(),
            _largeAdaOnlyUtxo(),
            _largeNativeAssetsUtxo(),
          ],
        ),
      ];

      const ExactBiggestAssetSelectionStrategy().apply(assetsGroup);

      expect(
        assetsGroup.first.value,
        orderedEquals([
          _largeAdaOnlyUtxo(),
          _smallAdaOnlyUtxo(),
          _largeNativeAssetsUtxo(),
          _smallNativeAssetsUtxo(),
        ]),
      );
    });
  });

  group(GreedySelectionStrategy, () {
    test('assets are sorted from biggest value to smallest value', () {
      final assetsGroup = [
        MapEntry(
          CoinSelector.adaAssetId,
          [
            _smallNativeAssetsUtxo(),
            _smallAdaOnlyUtxo(),
            _largeAdaOnlyUtxo(),
            _largeNativeAssetsUtxo(),
          ],
        ),
      ];

      const GreedySelectionStrategy().apply(assetsGroup);

      expect(
        assetsGroup.first.value,
        orderedEquals([
          _largeNativeAssetsUtxo(),
          _smallNativeAssetsUtxo(),
          _largeAdaOnlyUtxo(),
          _smallAdaOnlyUtxo(),
        ]),
      );
    });
  });
}

TransactionUnspentOutput _largeAdaOnlyUtxo() {
  return TransactionUnspentOutput(
    input: TransactionInput(transactionId: testTransactionHash, index: 0),
    output: TransactionOutput(
      address: testnetAddr,
      amount: const Balance(
        coin: Coin.fromWholeAda(100),
      ),
    ),
  );
}

TransactionUnspentOutput _largeNativeAssetsUtxo() {
  return TransactionUnspentOutput(
    input: TransactionInput(transactionId: testTransactionHash, index: 0),
    output: TransactionOutput(
      address: testnetAddr,
      amount: Balance(
        coin: const Coin.fromWholeAda(200),
        multiAsset: MultiAsset(
          bundle: {
            PolicyId('83714ccfc211d7f1e7a3c9e69ca4baaef46740c795deb9cbaa0ca37b'): {
              AssetName('RND'): const Coin(10000000),
            },
          },
        ),
      ),
    ),
  );
}

TransactionUnspentOutput _smallAdaOnlyUtxo() {
  return TransactionUnspentOutput(
    input: TransactionInput(transactionId: testTransactionHash, index: 0),
    output: TransactionOutput(
      address: testnetAddr,
      amount: const Balance(
        coin: Coin.fromWholeAda(2),
      ),
    ),
  );
}

TransactionUnspentOutput _smallNativeAssetsUtxo() {
  return TransactionUnspentOutput(
    input: TransactionInput(transactionId: testTransactionHash, index: 0),
    output: TransactionOutput(
      address: testnetAddr,
      amount: Balance(
        coin: Coin.fromAda(0.5),
        multiAsset: MultiAsset(
          bundle: {
            PolicyId('83714ccfc211d7f1e7a3c9e69ca4baaef46740c795deb9cbaa0ca37b'): {
              AssetName('RND'): const Coin(500),
            },
          },
        ),
      ),
    ),
  );
}
