import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/* cSpell:disable */
final mainnetAddr = ShelleyAddress.fromBech32(
  'addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqws'
  'x5wktcd8cc3sq835lu7drv2xwl2wywfgse35a3x',
);
final testnetAddr = ShelleyAddress.fromBech32(
  'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
);
final testnetChangeAddr = ShelleyAddress.fromBech32(
  'addr_test1qrqr2ved9h96x46yazq89yvcgk0r93gwk0shnv06yfrnfryqhpr26'
  'st0zgxmjnq6gqve99gtzxumclt9mwe5ynq03hjqgkjmhd',
);
final mainnetStakeAddr = ShelleyAddress.fromBech32(
  'stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw',
);
final testnetStakeAddr = ShelleyAddress.fromBech32(
  'stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn',
);

final testTransactionHash = TransactionHash.fromHex(
  '4c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff8570cd4be9a7',
);

TransactionUnspentOutput testUtxo() {
  return TransactionUnspentOutput(
    input: TransactionInput(
      transactionId: testTransactionHash,
      index: 0,
    ),
    output: TransactionOutput(
      address: ShelleyAddress.fromBech32(
        'addr_test1qpu5vlrf4xkxv2qpwngf6cjhtw542ayty80v8dyr49rf5'
        'ewvxwdrt70qlcpeeagscasafhffqsxy36t90ldv06wqrk2qum8x5w',
      ),
      amount: const Balance(coin: Coin(100000000)),
    ),
  );
}

Transaction minimalUnsignedTestTransaction() {
  return Transaction(
    body: TransactionBody(
      inputs: {testUtxo().input},
      outputs: [
        TransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        TransactionOutput(
          address: testnetChangeAddr,
          amount: const Balance(coin: Coin(9998833003)),
        ),
      ],
      fee: const Coin(166997),
    ),
    isValid: true,
    witnessSet: const TransactionWitnessSet(
      vkeyWitnesses: {},
    ),
  );
}

/// Returns a minimal transaction with optional fields skipped.
Transaction minimalSignedTestTransaction() {
  return Transaction(
    body: TransactionBody(
      inputs: {testUtxo().input},
      outputs: [
        TransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        TransactionOutput(
          address: testnetChangeAddr,
          amount: const Balance(coin: Coin(9998833003)),
        ),
      ],
      fee: const Coin(166997),
    ),
    isValid: true,
    witnessSet: TransactionWitnessSet(
      vkeyWitnesses: {
        VkeyWitness(
          vkey: Vkey.fromBytes(
            hex.decode(
              '3311ca404fcf22c91d607ace285d70e2'
              '263a1b81745c39673080329bd1a3f56e',
            ),
          ),
          signature: Ed25519Signature.fromBytes(
            hex.decode(
              '85b3a67a0529c95a740fd643e2998f03f251268ca'
              '603a0778b6631966b9a43fd2e02fa907c610ecc98'
              '5b375fa9852c14789dacd2ab7897b445efe4f4b0f60a06',
            ),
          ),
        ),
      },
    ),
  );
}

Transaction fullUnsignedTestTransaction() {
  final auxiliaryData = testAuxiliaryData();

  return Transaction(
    body: TransactionBody(
      inputs: {testUtxo().input},
      outputs: [
        TransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        TransactionOutput(
          address: testnetChangeAddr,
          amount: const Balance(coin: Coin(9998832827)),
        ),
      ],
      fee: const Coin(167173),
      ttl: const SlotBigNum(41193),
      auxiliaryDataHash: AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData),
      requiredSigners: {
        Vkey.fromBytes(
          hex.decode(
            '3311ca404fcf22c91d607ace285d70e2'
            '263a1b81745c39673080329bd1a3f56e',
          ),
        ),
      },
      networkId: NetworkId.testnet,
    ),
    isValid: true,
    witnessSet: const TransactionWitnessSet(
      vkeyWitnesses: {},
    ),
    auxiliaryData: auxiliaryData,
  );
}

/// Returns a full transaction with all possible optional fields.
Transaction fullSignedTestTransaction() {
  final auxiliaryData = testAuxiliaryData();

  return Transaction(
    body: TransactionBody(
      inputs: {testUtxo().input},
      outputs: [
        TransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        TransactionOutput(
          address: testnetChangeAddr,
          amount: const Balance(coin: Coin(9998832827)),
        ),
      ],
      fee: const Coin(167173),
      ttl: const SlotBigNum(41193),
      auxiliaryDataHash: AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData),
      requiredSigners: {
        Vkey.fromBytes(
          hex.decode(
            '3311ca404fcf22c91d607ace285d70e2'
            '263a1b81745c39673080329bd1a3f56e',
          ),
        ),
      },
      networkId: NetworkId.testnet,
    ),
    isValid: true,
    witnessSet: TransactionWitnessSet(
      vkeyWitnesses: {
        VkeyWitness(
          vkey: Vkey.fromBytes(
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
    ),
    auxiliaryData: auxiliaryData,
  );
}

AuxiliaryData testAuxiliaryData() {
  return AuxiliaryData(
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
}

/* cSpell:enable */
