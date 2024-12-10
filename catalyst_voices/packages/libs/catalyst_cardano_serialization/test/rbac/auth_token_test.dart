import 'dart:convert';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

// The certificate provided in the request
final _c509Cert = C509Certificate.fromHex(
  '''
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
      .replaceAll('\n', ''),
);

void main() {
  group(AuthToken, () {
    final kid = CertificateHash.fromC509Certificate(_c509Cert);
    final privateKey = Ed25519PrivateKey.seeded(0);
    final timestamp = DateTime.utc(2023);

    test('Generate AuthToken', () async {
      final token = await AuthToken.generate(
        kid: kid,
        privateKey: privateKey,
        timestamp: timestamp,
      );

      expect(token, startsWith('${AuthToken.prefix}.'));

      // Decode the base64 token part
      final parts = token.split('.');
      expect(parts.length, 2);

      final base64Token = parts[1];
      final decodedToken = base64Decode(base64Token);

      final decodedTokenAsArray = [
        0x83,
        ...decodedToken,
      ];

      // Decode the CBOR token
      final decodedCbor = cbor.decode(decodedTokenAsArray) as CborList;
      expect(decodedCbor.length, 3);

      final decodedKid = decodedCbor[0] as CborBytes;
      final decodedUuid = decodedCbor[1] as CborBytes;
      final decodedSignature = decodedCbor[2] as CborBytes;

      expect(decodedKid.bytes, (kid.toCbor() as CborBytes).bytes);

      expect(
        UuidV7.parseTimestamp(String.fromCharCodes(decodedUuid.bytes)),
        timestamp,
      );

      // Verify the signature
      final toBeSigned = [
        ...cbor.encode(kid.toCbor()),
        ...cbor.encode(decodedUuid),
      ];

      final publicKey = await privateKey.derivePublicKey();

      final isValid = await Ed25519().verify(
        toBeSigned,
        signature: Signature(
          decodedSignature.bytes,
          publicKey: SimplePublicKey(
            publicKey.bytes,
            type: KeyPairType.ed25519,
          ),
        ),
      );

      expect(isValid, isTrue);
    });
  });
}
