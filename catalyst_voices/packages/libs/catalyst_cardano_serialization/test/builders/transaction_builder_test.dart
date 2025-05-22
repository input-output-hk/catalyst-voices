import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

import '../test_utils/test_data.dart';

void main() {
  group(TransactionBuilder, () {
    test('transaction with native assets has correctly calculate fee', () {
      final changeAddress = ShelleyAddress.fromBech32(
        /* cSpell:disable */
        'addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg5'
        '5r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4'
        'ywuzuny7p7csr9kx9g',
        /* cSpell:enable */
      );

      final utxoWithNativeAssets = TransactionUnspentOutput.fromCbor(
        cbor.decode(
          hex.decode(
            '82825820d766cd9c60f3307d779892745047036d3fe578588f63a'
            'da8a454a1e51141bbf70182583900149c5b826b0dc7fab34736db'
            '3a7a3af9c8675e2229419f26dd9cd9cd5fc45e977cc791359a573'
            'bd3700fbf7d8a05ea0f1523b82e4c9e0fb1821b000000022a3b09'
            '96a2581c4a1686988e9b9ab944c0c166dc2fcc417a5e7fd186aa8'
            'f3a7bee40f6a1454d444558311a008e2975581ce16c2dc8ae937e'
            '8d3790c7fd7168d7b994621ba14ca11415f39fed72a1434d494e1'
            'a45009c08',
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
