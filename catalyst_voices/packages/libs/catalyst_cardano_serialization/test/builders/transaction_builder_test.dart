import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data.dart';

void main() {
  group(TransactionBuilder, () {
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
      ' throws $TransactionBalanceMismatchException',
      () {
        final utxo = TransactionUnspentOutput(
          input: TransactionInput(
            transactionId: TransactionHash.fromHex(
              'd766cd9c60f3307d779892745047036d3fe578588f63ada8a454a1e51141bbf7',
            ),
            index: 1,
          ),
          output: PreBabbageTransactionOutput(
            address: ShelleyAddress.fromBech32(
              /* cSpell:disable */
              'addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g',
              /* cSpell:enable */
            ),
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
          networkId: NetworkId.testnet,
        );

        expect(
          txBuilder.buildBody,
          throwsA(isA<TransactionBalanceMismatchException>()),
        );
      },
    );

    test('transaction with native assets has correctly calculated fee', () {
      final changeAddress = ShelleyAddress.fromBech32(
        /* cSpell:disable */
        'addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg5'
        '5r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4'
        'ywuzuny7p7csr9kx9g',
        /* cSpell:enable */
      );

      final utxoWithNativeAssets = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: TransactionHash.fromHex(
            'd766cd9c60f3307d779892745047036d3fe578588f63ada8a454a1e51141bbf7',
          ),
          index: 1,
        ),
        output: PreBabbageTransactionOutput(
          address: ShelleyAddress.fromBech32(
            /* cSpell:disable */
            'addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g',
            /* cSpell:enable */
          ),
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
      );

      final txBody =
          txBuilder.withOutput(txOutput).withChangeAddressIfNeeded(changeAddress).buildBody();

      expect(txBody.fee, equals(const Coin(170605)));
    });
  });
}
