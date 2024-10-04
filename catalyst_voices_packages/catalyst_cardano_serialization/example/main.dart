// ignore_for_file: avoid_print

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/* cSpell:disable */
void main() {
  const txBuilderConfig = TransactionBuilderConfig(
    feeAlgo: TieredFee(
      constant: 155381,
      coefficient: 44,
      refScriptByteCost: 15,
    ),
    maxTxSize: 16384,
    maxValueSize: 5000,
    coinsPerUtxoByte: Coin(4310),
  );

  final txMetadata = AuxiliaryData(
    map: {
      const CborSmallInt(1): CborString('Test'),
      const CborSmallInt(2): CborBytes(hex.decode('aabbccddeeff')),
      const CborSmallInt(3): const CborSmallInt(997),
      const CborSmallInt(4): cbor.decode(
        hex.decode(
          '82a50081825820afcf8497561065afe1ca623823508753cc580eb575ac8f1d6cfa'
          'a18c3ceeac010001818258390080f9e2c88e6c817008f3a812ed889b4a4da8e0bd'
          '103f86e7335422aa122a946b9ad3d2ddf029d3a828f0468aece76895f15c9efbd6'
          '9b42771a00df1560021a0002e63003182f075820bdc2b27e6869aa9a5fa23a1f1f'
          'd3a87025d8703df4fd7b120d058c839dc0415c82a10141aa80',
        ),
      ),
    },
  );

  final utxo = TransactionUnspentOutput(
    input: TransactionInput(
      transactionId: TransactionHash.fromHex(
        '4c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff8570cd4be9a7',
      ),
      index: 0,
    ),
    output: TransactionOutput(
      address: ShelleyAddress.fromBech32(
        'addr_test1qpu5vlrf4xkxv2qpwngf6cjhtw542ayty80v8dyr49rf5ewvxwdrt70'
        'qlcpeeagscasafhffqsxy36t90ldv06wqrk2qum8x5w',
      ),
      amount: const Balance(coin: Coin(10162333)),
    ),
  );

  final txOutput = TransactionOutput(
    address: ShelleyAddress.fromBech32(
      'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
    ),
    amount: const Balance(coin: Coin(1000000)),
  );

  final txBuilder = TransactionBuilder(
    config: txBuilderConfig,
    inputs: {utxo},
    // fee can be left empty so that it's auto calculated or can be hardcoded
    // fee: const Coin(1000000),
    ttl: const SlotBigNum(410021),
    auxiliaryData: txMetadata,
    networkId: NetworkId.testnet,
  );

  final changeAddress = ShelleyAddress.fromBech32(
    'addr_test1qrqr2ved9h96x46yazq89yvcgk0r93gwk0shnv06yfrnfryqhpr26'
    'st0zgxmjnq6gqve99gtzxumclt9mwe5ynq03hjqgkjmhd',
  );

  final txBody = txBuilder
      .withOutput(txOutput)
      .withChangeAddressIfNeeded(changeAddress)
      // fee can be set manually or left empty to be auto calculated
      // .withFee(const Coin(10000000))
      .buildBody();

  final unsignedTx = Transaction(
    body: txBody,
    isValid: true,
    witnessSet: const TransactionWitnessSet(),
  );

  final witnessSet = _signTransaction(unsignedTx);

  final signedTx = Transaction(
    body: txBody,
    isValid: true,
    witnessSet: witnessSet,
    auxiliaryData: txMetadata,
  );

  final txBytes = cbor.encode(signedTx.toCbor());
  final txBytesHex = hex.encode(txBytes);
  print(txBytesHex);
}

TransactionWitnessSet _signTransaction(Transaction transaction) {
  // return a fake witness set, in real world the wallet
  // would sign the transaction hash and provide this
  return TransactionWitnessSet(
    vkeyWitnesses: {
      VkeyWitness(
        vkey: Ed25519PublicKey.fromBytes(
          hex.decode(
            '3311ca404fcf22c91d607ace285d70e2'
            '263a1b81745c39673080329bd1a3f56e',
          ),
        ),
        signature: Ed25519Signature.fromBytes(
          hex.decode(
            'f5eb006f048fdfa9b81b0fe3abee1ce1f1a75789d'
            'c21088b23ebf95c76b050ad157a497999e083e1957'
            'c2a3d730a07a5b2aef4a755783c9ce778c02c4a08970f',
          ),
        ),
      ),
    },
  );
}

/* cSpell:enable */
