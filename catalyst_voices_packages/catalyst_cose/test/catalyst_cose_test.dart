import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

const int _coseSign1Tag = 18;

void main() {
  group('CatalystCose', () {
    late Ed25519 algorithm;
    late SimpleKeyPair keyPair;
    late List<int> privateKey;
    late SimplePublicKey publicKey;

    setUp(() async {
      // Initialize the Ed25519 algorithm and generate a key pair
      algorithm = Ed25519();
      keyPair = await algorithm.newKeyPair();
      privateKey = await keyPair.extractPrivateKeyBytes();
      publicKey = await keyPair.extractPublicKey();
    });

    test('sign1 generates a valid COSE_SIGN1 structure', () async {
      final payload = List<int>.generate(10, (i) => i); // Example payload

      // Call the sign1 method
      final coseSign1 = await CatalystCose.sign1(
        privateKey: privateKey,
        payload: payload,
      );

      // Verify that the COSE_SIGN1 structure is a valid CborList
      expect(coseSign1, isA<CborList>());

      final cborList = coseSign1 as CborList;
      expect(cborList.length, 4); // Should contain 4 items

      final protectedHeader = cborList[0];
      expect(protectedHeader, isA<CborBytes>());

      final unprotectedHeader = cborList[1];
      expect(unprotectedHeader, isA<CborMap>());

      final signedPayload = cborList[2];
      expect(signedPayload, isA<CborBytes>());
      expect(
        (signedPayload as CborBytes).bytes,
        payload,
      ); // Check that the payload is as expected

      final signature = cborList[3];
      // The actual signature bytes are not known in advance; just verify the type
      expect(signature, isA<CborBytes>());
    });

    test('verifyCoseSign1 validates correct signature', () async {
      final payload = List<int>.generate(10, (i) => i); // Example payload

      // Call the sign1 method
      final coseSign1 = await CatalystCose.sign1(
        privateKey: privateKey,
        payload: payload,
      );

      // Verify the signature
      final isValid = await CatalystCose.verifyCoseSign1(
        coseSign1: coseSign1,
        publicKey: publicKey.bytes,
      );

      expect(isValid, true); // Check that the signature is valid
    });

    test('verifyCoseSign1 rejects invalid signatures', () async {
      final payload = List<int>.generate(10, (i) => i); // Example payload

      // Call the sign1 method
      final coseSign1 = await CatalystCose.sign1(
        privateKey: privateKey,
        payload: payload,
      );

      // Tamper with the signature to invalidate it
      final cborList = coseSign1 as CborList;
      final tamperedSignature = CborBytes(
        List<int>.generate(64, (i) => i),
      ); // Example tampered signature
      final tamperedCoseSign1 = CborList(
        [
          cborList[0], // protected header
          cborList[1], // unprotected header
          cborList[2], // payload
          tamperedSignature,
        ],
        tags: [_coseSign1Tag],
      );

      // Verify the tampered signature
      final isValid = await CatalystCose.verifyCoseSign1(
        coseSign1: tamperedCoseSign1,
        publicKey: publicKey.bytes,
      );

      expect(isValid, false); // Check that the signature is invalid
    });

    test('verifyCoseSign1 handles invalid COSE_SIGN1 structure', () async {
      // Construct an invalid COSE_SIGN1 structure
      final invalidCoseSign1 = CborList(
        [
          CborBytes(
            List<int>.generate(1, (i) => i),
          ), // Invalid protected header
          CborMap({}),
          CborBytes([]),
          CborBytes(List<int>.generate(64, (i) => i)), // Invalid signature
        ],
        tags: [_coseSign1Tag],
      );

      // Verify the invalid COSE_SIGN1 structure
      final isValid = await CatalystCose.verifyCoseSign1(
        coseSign1: invalidCoseSign1,
        publicKey: publicKey.bytes,
      );

      expect(isValid, false); // Check that the verification fails
    });
  });
}
