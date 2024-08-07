import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

import 'test_utils/test_data.dart';

void main() {
  group(Transaction, () {
    test('full signed transaction serialized to cbor', () {
      _testTransactionSerialization(
        fullSignedTestTransaction(),
        '84a700818258204c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff85'
        '70cd4be9a700018282581d6082e016828989cd9d809b50d6976d9efa9bc5b2c1a78d'
        '4b3bfa1bb83b1a000f424082583900c035332d2dcba35744e880729198459e32c50e'
        'b3e179b1fa2247348c80b846ad416f120db94c1a401992950b11b9bc7d65dbb3424c'
        '0f8de41b0000000253fa14bb021a00028d050319a0e907582057b9d4976bc8017e5b'
        '95c6996bac1749765e188c990b5c705a65c78f8349227d0e8158203311ca404fcf22'
        'c91d607ace285d70e2263a1b81745c39673080329bd1a3f56e0f00a1008182582033'
        '11ca404fcf22c91d607ace285d70e2263a1b81745c39673080329bd1a3f56e5840f5'
        'eb006f048fdfa9b81b0fe3abee1ce1f1a75789dc21088b23ebf95c76b050ad157a49'
        '7999e083e1957c2a3d730a07a5b2aef4a755783c9ce778c02c4a08970ff5a4016454'
        '6573740246aabbccddeeff031903e50482a50081825820afcf8497561065afe1ca62'
        '3823508753cc580eb575ac8f1d6cfaa18c3ceeac010001818258390080f9e2c88e6c'
        '817008f3a812ed889b4a4da8e0bd103f86e7335422aa122a946b9ad3d2ddf029d3a8'
        '28f0468aece76895f15c9efbd69b42771a00df1560021a0002e63003182f075820bd'
        'c2b27e6869aa9a5fa23a1f1fd3a87025d8703df4fd7b120d058c839dc0415c82a101'
        '41aa80',
      );
    });

    test('full signed transaction serialized to and from cbor', () {
      _testTransactionSerializationRoundTrip(fullSignedTestTransaction());
    });

    test('full unsigned transaction serialized to cbor', () {
      _testTransactionSerialization(
        fullUnsignedTestTransaction(),
        '84a700818258204c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff85'
        '70cd4be9a700018282581d6082e016828989cd9d809b50d6976d9efa9bc5b2c1a78d'
        '4b3bfa1bb83b1a000f424082583900c035332d2dcba35744e880729198459e32c50e'
        'b3e179b1fa2247348c80b846ad416f120db94c1a401992950b11b9bc7d65dbb3424c'
        '0f8de41b0000000253fa14bb021a00028d050319a0e907582057b9d4976bc8017e5b'
        '95c6996bac1749765e188c990b5c705a65c78f8349227d0e8158203311ca404fcf22'
        'c91d607ace285d70e2263a1b81745c39673080329bd1a3f56e0f00a0f5a401645465'
        '73740246aabbccddeeff031903e50482a50081825820afcf8497561065afe1ca6238'
        '23508753cc580eb575ac8f1d6cfaa18c3ceeac010001818258390080f9e2c88e6c81'
        '7008f3a812ed889b4a4da8e0bd103f86e7335422aa122a946b9ad3d2ddf029d3a828'
        'f0468aece76895f15c9efbd69b42771a00df1560021a0002e63003182f075820bdc2'
        'b27e6869aa9a5fa23a1f1fd3a87025d8703df4fd7b120d058c839dc0415c82a10141'
        'aa80',
      );
    });

    test('full unsigned transaction serialized to and from cbor', () {
      _testTransactionSerializationRoundTrip(fullUnsignedTestTransaction());
    });

    test('minimal signed transaction serialized to cbor', () {
      _testTransactionSerialization(
        minimalSignedTestTransaction(),
        '84a300818258204c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff857'
        '0cd4be9a700018282581d6082e016828989cd9d809b50d6976d9efa9bc5b2c1a78d4b'
        '3bfa1bb83b1a000f424082583900c035332d2dcba35744e880729198459e32c50eb3e'
        '179b1fa2247348c80b846ad416f120db94c1a401992950b11b9bc7d65dbb3424c0f8d'
        'e41b0000000253fa156b021a00028c55a100818258203311ca404fcf22c91d607ace2'
        '85d70e2263a1b81745c39673080329bd1a3f56e584085b3a67a0529c95a740fd643e2'
        '998f03f251268ca603a0778b6631966b9a43fd2e02fa907c610ecc985b375fa9852c1'
        '4789dacd2ab7897b445efe4f4b0f60a06f5f6',
      );
    });

    test('minimal signed transaction serialized to and from cbor', () {
      _testTransactionSerializationRoundTrip(
        minimalSignedTestTransaction(),
      );
    });

    test('minimal unsigned transaction serialized to and from cbor', () {
      _testTransactionSerializationRoundTrip(fullUnsignedTestTransaction());
    });

    test('minimal unsigned transaction serialized to cbor', () {
      _testTransactionSerialization(
        minimalUnsignedTestTransaction(),
        '84a300818258204c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff85'
        '70cd4be9a700018282581d6082e016828989cd9d809b50d6976d9efa9bc5b2c1a78d'
        '4b3bfa1bb83b1a000f424082583900c035332d2dcba35744e880729198459e32c50e'
        'b3e179b1fa2247348c80b846ad416f120db94c1a401992950b11b9bc7d65dbb3424c'
        '0f8de41b0000000253fa156b021a00028c55a0f5f6',
      );
    });

    test('minimal unsigned transaction serialized to and from cbor', () {
      _testTransactionSerializationRoundTrip(
        minimalUnsignedTestTransaction(),
      );
    });
  });
}

void _testTransactionSerializationRoundTrip(Transaction transaction) {
  final hex1 = hex.encode(cbor.encode(transaction.toCbor()));
  final tx1 = Transaction.fromCbor(cbor.decode(hex.decode(hex1)));
  final hex2 = hex.encode(cbor.encode(tx1.toCbor()));

  expect(hex1, equals(hex2));
}

void _testTransactionSerialization(
  Transaction transaction,
  String expectedHex,
) {
  final bytes = cbor.encode(transaction.toCbor());
  final hexString = hex.encode(bytes);

  expect(hexString, equals(expectedHex));
}
