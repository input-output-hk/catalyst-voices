import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/transaction_output.dart';
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
    output: PreBabbageTransactionOutput(
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
        PreBabbageTransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        PreBabbageTransactionOutput(
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
        PreBabbageTransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        PreBabbageTransactionOutput(
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
          vkey: Ed25519PublicKey.fromBytes(
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
        PreBabbageTransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        PreBabbageTransactionOutput(
          address: testnetChangeAddr,
          amount: const Balance(coin: Coin(9998832827)),
        ),
      ],
      fee: const Coin(167173),
      ttl: const SlotBigNum(41193),
      auxiliaryDataHash: AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData),
      requiredSigners: {
        Ed25519PublicKeyHash.fromPublicKey(
          Ed25519PublicKey.fromBytes(
            hex.decode(
              '3311ca404fcf22c91d607ace285d70e2'
              '263a1b81745c39673080329bd1a3f56e',
            ),
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
        PreBabbageTransactionOutput(
          address: testnetAddr,
          amount: const Balance(coin: Coin(1000000)),
        ),
        PreBabbageTransactionOutput(
          address: testnetChangeAddr,
          amount: const Balance(coin: Coin(9998832827)),
        ),
      ],
      fee: const Coin(167173),
      ttl: const SlotBigNum(41193),
      auxiliaryDataHash: AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData),
      requiredSigners: {
        Ed25519PublicKeyHash.fromPublicKey(
          Ed25519PublicKey.fromBytes(
            hex.decode(
              '3311ca404fcf22c91d607ace285d70e2'
              '263a1b81745c39673080329bd1a3f56e',
            ),
          ),
        ),
      },
      networkId: NetworkId.testnet,
    ),
    isValid: true,
    witnessSet: TransactionWitnessSet(
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

final derCertHex = '''
308202343082019DA00302010202145A
FC371DAF301793CF0B1835A118C2F903
63D5D9300D06092A864886F70D01010B
05003045310B30090603550406130241
553113301106035504080C0A536F6D65
2D53746174653121301F060355040A0C
18496E7465726E657420576964676974
7320507479204C7464301E170D323430
3731313038353733365A170D32353037
31313038353733365A3045310B300906
03550406130241553113301106035504
080C0A536F6D652D5374617465312130
1F060355040A0C18496E7465726E6574
205769646769747320507479204C7464
30819F300D06092A864886F70D010101
050003818D0030818902818100CD28E2
0B157CA70C85433C1689B1D5890EC479
BDD1FFDCC5647AE12BE9BADF4AF20764
CD24BD64130831A57506DFBBDD3E924C
96B259C6CCEDF24D6A25618F0819643C
739F145B733C3C94333E5937B499ADA9
A4FFC127457C7CB557F2F5623DCADEA1
E06F09129DB9584B0AEE949244B3252B
52AFDE5D385C65E563A6EFB07F020301
0001A321301F301D0603551D0E041604
1492EB169818B833588321957A846077
AA239CF3A0300D06092A864886F70D01
010B0500038181002E5F73333CE667E4
172B252416EAA1D2E9681F59943724B4
F366A8B930443CA6B69B12DD9DEBEE9C
8A6307695EE1884DA4B00136195D1D82
23D1C253FF408EDFC8ED03AF1819244C
35D3843855FB9AF86E84FB7636FA3F4A
0FC396F6FB6FD16D3BCEBDE68A8BD81B
E61E8EE7D77E9F7F9804E03EBC31B458
1313C955A667658B
'''
    .replaceAll('\n', '');

final c509CertHex = '''
8B004301F50D6B524643207465737420
43411A63B0CD001A6955B90047010123
456789AB01582102B1216AB96E5B3B33
40F5BDF02E693F16213A04525ED44450
B1019C2DFD3838AB010058406FC90301
5259A38C0800A3D0B2969CA21977E8ED
6EC344964D4E1C6B37C8FB541274C3BB
81B2F53073C5F101A5AC2A92886583B6
A2679B6E682D2A26945ED0B2
'''
    .replaceAll('\n', '');

/* cSpell:enable */
