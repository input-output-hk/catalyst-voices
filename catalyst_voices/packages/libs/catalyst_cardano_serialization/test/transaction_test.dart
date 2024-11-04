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
        '95c6996bac1749765e188c990b5c705a65c78f8349227d0e81581cc035332d2dcba3'
        '5744e880729198459e32c50eb3e179b1fa2247348c0f00a100818258203311ca404f'
        'cf22c91d607ace285d70e2263a1b81745c39673080329bd1a3f56e5840f5eb006f04'
        '8fdfa9b81b0fe3abee1ce1f1a75789dc21088b23ebf95c76b050ad157a497999e083'
        'e1957c2a3d730a07a5b2aef4a755783c9ce778c02c4a08970ff5a401645465737402'
        '46aabbccddeeff031903e50482a50081825820afcf8497561065afe1ca6238235087'
        '53cc580eb575ac8f1d6cfaa18c3ceeac010001818258390080f9e2c88e6c817008f3'
        'a812ed889b4a4da8e0bd103f86e7335422aa122a946b9ad3d2ddf029d3a828f0468a'
        'ece76895f15c9efbd69b42771a00df1560021a0002e63003182f075820bdc2b27e68'
        '69aa9a5fa23a1f1fd3a87025d8703df4fd7b120d058c839dc0415c82a10141aa80',
      );
    });

    test('full signed transaction serialized to and from cbor', () {
      _testTransactionSerializationRoundTrip(fullSignedTestTransaction());
    });

    test('full unsigned transaction serialized to cbor', () {
      _testTransactionSerialization(
        fullUnsignedTestTransaction(),
        '84a700818258204c1fbc5433ec764164945d736a09dc087d59ff30e64d26d462ff857'
        '0cd4be9a700018282581d6082e016828989cd9d809b50d6976d9efa9bc5b2c1a78d4b'
        '3bfa1bb83b1a000f424082583900c035332d2dcba35744e880729198459e32c50eb3e'
        '179b1fa2247348c80b846ad416f120db94c1a401992950b11b9bc7d65dbb3424c0f8d'
        'e41b0000000253fa14bb021a00028d050319a0e907582057b9d4976bc8017e5b95c69'
        '96bac1749765e188c990b5c705a65c78f8349227d0e81581cc035332d2dcba35744e8'
        '80729198459e32c50eb3e179b1fa2247348c0f00a0f5a40164546573740246aabbccd'
        'deeff031903e50482a50081825820afcf8497561065afe1ca623823508753cc580eb5'
        '75ac8f1d6cfaa18c3ceeac010001818258390080f9e2c88e6c817008f3a812ed889b4'
        'a4da8e0bd103f86e7335422aa122a946b9ad3d2ddf029d3a828f0468aece76895f15c'
        '9efbd69b42771a00df1560021a0002e63003182f075820bdc2b27e6869aa9a5fa23a1'
        'f1fd3a87025d8703df4fd7b120d058c839dc0415c82a10141aa80',
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

    test('on-chain complex transaction serialized from and to cbor', () {
      const hex1 =
          '84ab0082825820f72db06cf05d94b184209b0a0a868fc249a4f9e6347e4e95a1b9b0'
          'fb207cdd1d0b825820f72db06cf05d94b184209b0a0a868fc249a4f9e6347e4e95a1'
          'b9b0fb207cdd1d181d0184a300581d705d2470cbd75a4e78c7f72a6f1f19a3ae6d1e'
          'd673a8343ffa084119a801821a0cfe6a80a0028201d818582bd8799f581cd5c9e461'
          '7211e2ff7c7fd01d0de9ac82e5bb81dc5a5e16b59911866a1b00000190d6052db0ff'
          'a300581d7062bac7f9f130121bd89270a98900f8e4845c788675f6e0d8dd90e02f01'
          '821a00151c56a1581c490738c27186a3389e38b96b3e3493f1ce955bff43a1daba4f'
          'f122dba1416901028201d818584fd8799f01d8798044696c61704131582006c56b73'
          'bcea44f3e37aaf3dba42c9add608b1066248e7f69cc76feeb78ead48581c5223613e'
          '39d8299c9394781b8a6a2e4055897586f80e21cefd4f56aaff82583900d5c9e46172'
          '11e2ff7c7fd01d0de9ac82e5bb81dc5a5e16b59911866a2f58247e06e3a792a3649f'
          '9923a6934d56ef150ab5bb9d15db287fe5821a00115cb0a1581c5223613e39d8299c'
          '9394781b8a6a2e4055897586f80e21cefd4f56aaa144696c61700182583900d5c9e4'
          '617211e2ff7c7fd01d0de9ac82e5bb81dc5a5e16b59911866a2f58247e06e3a792a3'
          '649f9923a6934d56ef150ab5bb9d15db287fe51b0000000237fb222c021a0004620a'
          '031a0345fbe4081a0345fba809a1581c5223613e39d8299c9394781b8a6a2e405589'
          '7586f80e21cefd4f56aaa144696c6170010b5820cc26bf5b2930452161ec613b5ff5'
          '386a0146d448778ec6c516260b0add4ebab30d81825820f72db06cf05d94b184209b'
          '0a0a868fc249a4f9e6347e4e95a1b9b0fb207cdd1d181d1082583900d5c9e4617211'
          'e2ff7c7fd01d0de9ac82e5bb81dc5a5e16b59911866a2f58247e06e3a792a3649f99'
          '23a6934d56ef150ab5bb9d15db287fe5821a000eedc2a0111b000000024500a0fc12'
          '82825820f72db06cf05d94b184209b0a0a868fc249a4f9e6347e4e95a1b9b0fb207c'
          'dd1d01825820f72db06cf05d94b184209b0a0a868fc249a4f9e6347e4e95a1b9b0fb'
          '207cdd1d00a2008182582002440b1de68453a43b489d2971f49f03e311accfa6efa2'
          'c577d537b18deb5d675840bac28150d717e3a7b077b195cd1cf9620ee01d973a7e6d'
          '35af8c2e1ef5b9b5311a1c81b5c700590b0854fa089ed1d93b3d0780decca12559bb'
          '3e91b53d4e330d0582840000d87980821a00037c8d1a055940fd840100d8799fd879'
          '9fd8799f41304168416affd8799f41304168416affd8799f58203a34a78764bea088'
          'a63800dcd306ad6bee0e8868a7c36948ac3955a3271b2e98d87a9f5820e3b0c44298'
          'fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855ffd87a9f5820e3'
          'b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855ffffff'
          'ff821a000b0a3d1a106ae424f5f6';

      final serialized = cbor.decode(hex.decode(hex1));
      final tx = Transaction.fromCbor(serialized);
      final hex2 = hex.encode(cbor.encode(tx.toCbor()));
      expect(hex1, equals(hex2));
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
