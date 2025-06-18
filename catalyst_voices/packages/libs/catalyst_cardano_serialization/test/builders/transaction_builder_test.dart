import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import '../test_utils/fee_utils.dart';
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
          transactionId: testTransactionHash,
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
          transactionId: testTransactionHash,
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
          transactionId: testTransactionHash,
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

    test(
        'transaction output with too many assets '
        'throws $TxMaxAssetsPerOutputExceededException', () {
      final changeAddress = SelectionUtils.randomAddress();
      final policyId = PolicyId(SelectionUtils.randomHexString(PolicyId.hashLength));

      final utxoWithNativeAssets = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: Balance(
            coin: const Coin(9298446742),
            multiAsset: MultiAsset(
              bundle: {
                policyId: {
                  AssetName('ASSET_1'): const Coin(100),
                  AssetName('ASSET_2'): const Coin(100),
                },
              },
            ),
          ),
        ),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(maxAssetsPerOutput: 1),
        inputs: {utxoWithNativeAssets},
        outputs: [
          PreBabbageTransactionOutput(
            address: testnetAddr,
            amount: Balance(
              coin: const Coin(2000000),
              multiAsset: MultiAsset(
                bundle: {
                  policyId: {
                    AssetName('ASSET_1'): const Coin(100),
                    AssetName('ASSET_2'): const Coin(100),
                  },
                },
              ),
            ),
          ),
        ],
        networkId: NetworkId.testnet,
        changeAddress: changeAddress,
      );

      final updatedTxBuilder = txBuilder.withChangeIfNeeded();

      expect(
        updatedTxBuilder.buildBody,
        throwsA(isA<TxMaxAssetsPerOutputExceededException>()),
      );
    });

    test(
        'transaction with utxos each below min ada required '
        'for change output will prefer selecting two utxos '
        'over burning remaining Ada as fee', () {
      final changeAddress = SelectionUtils.randomAddress();
      const ada = Coin(969750);

      final utxos = List.generate(5, (index) {
        return TransactionUnspentOutput(
          input: TransactionInput(
            transactionId: TransactionHash.fromHex(
              SelectionUtils.randomHexString(TransactionHash.hashLength),
            ),
            index: index,
          ),
          output: PreBabbageTransactionOutput(
            address: changeAddress,
            amount: const Balance(coin: ada),
          ),
        );
      });

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: utxos.toSet(),
        networkId: NetworkId.testnet,
        changeAddress: changeAddress,
      );

      final txBody = txBuilder.applySelection().buildBody();
      expect(txBody.inputs, hasLength(2));
      expect(txBody.fee, lessThan(ada));
    });

    test(
        'transaction with one utxo below min ada required '
        'for change output will burn remaining ada as fee '
        'when change output strategy allows to burn ada', () {
      final changeAddress = SelectionUtils.randomAddress();
      const ada = Coin(969750);

      final utxo = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: changeAddress,
          amount: const Balance(coin: ada),
        ),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: {utxo},
        networkId: NetworkId.testnet,
        changeAddress: changeAddress,
      );

      final txBody = txBuilder
          .applySelection(
            // ignore: avoid_redundant_argument_values
            changeOutputStrategy: ChangeOutputAdaStrategy.burn,
          )
          .buildBody();

      expect(txBody.inputs, hasLength(1));
      expect(txBody.fee, equals(ada));
    });

    test(
        'transaction with one utxo below min ada required '
        'for change output will throw exception '
        'when change output strategy does not allow to burn ada', () {
      final changeAddress = SelectionUtils.randomAddress();
      const ada = Coin(969750);

      final utxo = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: changeAddress,
          amount: const Balance(coin: ada),
        ),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(),
        inputs: {utxo},
        networkId: NetworkId.testnet,
        changeAddress: changeAddress,
      );

      expect(
        () => txBuilder
            .applySelection(
              changeOutputStrategy: ChangeOutputAdaStrategy.noBurn,
            )
            .buildBody(),
        throwsA(isA<InsufficientUtxoBalanceException>()),
      );
    });

    test('transaction with native assets has correctly calculated fee', () {
      final changeAddress = SelectionUtils.randomAddress();

      final utxoWithNativeAssets = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: testTransactionHash,
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

    test(
        'transaction with maximum allowed native tokens in '
        'a single output should create a single output', () {
      const maxNativeAssetsFittingInSingleOutput = 1011;
      final changeAddress = SelectionUtils.randomAddress();

      final utxoWithNativeAssets = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: Balance(
            coin: const Coin(81111040),
            multiAsset: MultiAsset(
              bundle: {
                PolicyId('00000000000000000000000000000000000000000000000000000000'): {
                  for (int i = 0; i < maxNativeAssetsFittingInSingleOutput; i++)
                    AssetName('$i'): const Coin(1),
                },
              },
            ),
          ),
        ),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(maxAssetsPerOutput: 2000),
        inputs: {utxoWithNativeAssets},
        changeAddress: changeAddress,
      );

      final updatedBuilder = txBuilder.applySelection();
      final txBody = updatedBuilder.buildBody();
      final transaction = Transaction(
        body: txBody,
        isValid: true,
        witnessSet: TransactionBuilder.generateFakeWitnessSet(
          updatedBuilder.inputs,
          updatedBuilder.requiredSigners,
        ),
        auxiliaryData: updatedBuilder.auxiliaryData,
      );

      verifyTransactionFee(transaction, updatedBuilder);
      expect(txBody.outputs, hasLength(1));
    });

    test(
        'transaction with one over the maximum allowed native tokens '
        'in a single output should create two outputs', () {
      const maxNativeAssetsFittingInSingleOutput = 1011;
      final changeAddress = SelectionUtils.randomAddress();

      final utxoWithNativeAssets = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: SelectionUtils.randomAddress(),
          amount: Balance(
            coin: const Coin(81111040),
            multiAsset: MultiAsset(
              bundle: {
                PolicyId('00000000000000000000000000000000000000000000000000000000'): {
                  for (int i = 0; i <= maxNativeAssetsFittingInSingleOutput; i++)
                    AssetName('$i'): const Coin(1),
                },
              },
            ),
          ),
        ),
      );

      final txBuilder = TransactionBuilder(
        config: transactionBuilderConfig(maxAssetsPerOutput: 2000),
        inputs: {utxoWithNativeAssets},
        changeAddress: changeAddress,
      );

      final updatedBuilder = txBuilder.applySelection();
      final txBody = updatedBuilder.buildBody();
      final transaction = Transaction(
        body: txBody,
        isValid: true,
        witnessSet: TransactionBuilder.generateFakeWitnessSet(
          updatedBuilder.inputs,
          updatedBuilder.requiredSigners,
        ),
        auxiliaryData: updatedBuilder.auxiliaryData,
      );

      verifyTransactionFee(transaction, updatedBuilder);
      expect(txBody.outputs, hasLength(2));

      final firstOutput = txBody.outputs[0];
      expect(
        firstOutput.amount.listNonZeroAssetIds(),
        // length: ada asset + native assets
        hasLength(maxNativeAssetsFittingInSingleOutput + 1),
      );

      final secondOutput = txBody.outputs[1];
      expect(
        secondOutput.amount.listNonZeroAssetIds(),
        // length: ada asset + single native asset
        hasLength(2),
      );
    });
  });
}
