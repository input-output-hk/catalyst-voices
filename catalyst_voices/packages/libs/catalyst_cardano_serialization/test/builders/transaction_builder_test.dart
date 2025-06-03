import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import '../test_utils/selection_utils.dart';
import '../test_utils/test_data.dart';

void main() {
  group(TransactionBuilder, () {
    test(
        'transaction with outputs with too little '
        ' ada throws $TxValueBelowMinUtxoValueException', () {
      final txOutput = PreBabbageTransactionOutput(
        address: testnetAddr,
        amount: const Balance(coin: Coin(1)),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: const {},
        outputs: [txOutput],
        fee: Coin.fromAda(0.2),
      );

      expect(
        txBuilder.buildBody,
        throwsA(isA<TxValueBelowMinUtxoValueException>()),
      );
    });

    test('transaction with too big outputs throws $TxValueSizeExceededException', () {
      final txOutput = PreBabbageTransactionOutput(
        address: testnetAddr,
        amount: Balance(
          coin: const Coin.fromWholeAda(10),
          multiAsset: MultiAsset(
            bundle: {
              for (int i = 0; i < 150; i++)
                PolicyId(SelectionUtils.randomHexString(PolicyId.hashLength)): {
                  AssetName('RND'): Coin(i),
                },
            },
          ),
        ),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: const {},
        outputs: [txOutput],
        fee: Coin.fromAda(0.2),
      );

      expect(
        txBuilder.buildBody,
        throwsA(isA<TxValueSizeExceededException>()),
      );
    });

    test('transaction without fee throws $TxFeeNotSpecifiedException', () {
      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: const {},
      );

      expect(
        txBuilder.buildBody,
        throwsA(isA<TxFeeNotSpecifiedException>()),
      );
    });

    test(
        'transaction with mismatch between inputs and outputs'
        ' throws $TxBalanceMismatchException', () {
      final utxo = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: TransactionHash.fromHex(
            'd766cd9c60f3307d779892745047036d3fe578588f63ada8a454a1e51141bbf7',
          ),
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: const Balance(
            coin: Coin.fromWholeAda(1),
          ),
        ),
      );

      final txOutput = PreBabbageTransactionOutput(
        address: testnetAddr,
        amount: const Balance(coin: Coin.fromWholeAda(2)),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: {utxo},
        outputs: [txOutput],
        fee: Coin.fromAda(0.2),
      );

      expect(
        txBuilder.buildBody,
        throwsA(isA<TxBalanceMismatchException>()),
      );
    });

    test('transaction with too small fee throws $TxFeeTooSmallException', () {
      final utxo = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: TransactionHash.fromHex(
            'd766cd9c60f3307d779892745047036d3fe578588f63ada8a454a1e51141bbf7',
          ),
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: const Balance(
            coin: Coin.fromWholeAda(1),
          ),
        ),
      );

      final txOutput = PreBabbageTransactionOutput(
        address: testnetAddr,
        amount: const Balance(coin: Coin(900000)),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: {utxo},
        outputs: [txOutput],
        fee: const Coin(100000),
      );

      expect(
        txBuilder.buildBody,
        throwsA(isA<TxFeeTooSmallException>()),
      );
    });

    test('transaction too large throws $MaxTxSizeExceededException', () {
      final utxo = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: TransactionHash.fromHex(
            'd766cd9c60f3307d779892745047036d3fe578588f63ada8a454a1e51141bbf7',
          ),
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: const Balance(
            coin: Coin.fromWholeAda(1002),
          ),
        ),
      );

      final txOutput = PreBabbageTransactionOutput(
        address: testnetAddr,
        amount: const Balance(coin: Coin.fromWholeAda(1)),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: {utxo},
        outputs: List.filled(1000, txOutput),
        fee: const Coin.fromWholeAda(2),
      );

      expect(
        txBuilder.buildBody,
        throwsA(isA<MaxTxSizeExceededException>()),
      );
    });

    test('transaction with native assets has correctly calculated fee', () {
      final changeAddress = SelectionUtils.randomAddress();

      final utxoWithNativeAssets = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: TransactionHash.fromHex(
            'd766cd9c60f3307d779892745047036d3fe578588f63ada8a454a1e51141bbf7',
          ),
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: Balance(
            coin: const Coin(9298446742),
            multiAsset: MultiAsset(
              bundle: {
                PolicyId('4a1686988e9b9ab944c0c166dc2fcc417a5e7fd186aa8f3a7bee40f6'): {
                  /* cSpell:disable */
                  AssetName('MDEX1'): const Coin(9316725),
                  /* cSpell:enable */
                },
                PolicyId('e16c2dc8ae937e8d3790c7fd7168d7b994621ba14ca11415f39fed72'): {
                  AssetName('MIN'): const Coin(1157667848),
                },
              },
            ),
          ),
        ),
      );

      final txOutput = PreBabbageTransactionOutput(
        address: testnetAddr,
        amount: const Balance(coin: Coin(1000000)),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: {utxoWithNativeAssets},
        networkId: NetworkId.testnet,
        changeAddress: changeAddress,
      );

      final txBody = txBuilder.withOutput(txOutput).withChangeIfNeeded().buildBody();

      expect(txBody.fee, equals(const Coin(170605)));
    });
  });
}
