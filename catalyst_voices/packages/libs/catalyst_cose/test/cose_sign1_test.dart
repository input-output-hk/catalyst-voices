import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

void main() {
  group(CoseSign1, () {
    const uuidV4 = 'e9aba14f-d05b-49b2-b5b5-100595853384';
    const uuidV7 = '0193b535-7196-7cd1-84e6-ad9c316cf2d2';
    late _SignerVerifier signerVerifier;

    setUp(() async {
      // Initialize the Ed25519 algorithm and generate a key pair
      final algorithm = Ed25519();
      final keyPair = await algorithm.newKeyPairFromSeed(List.filled(32, 0));
      signerVerifier = _SignerVerifier(algorithm, keyPair);
    });

    test('sign generates a valid COSE_SIGN1 structure', () async {
      final coseSign1 = await CoseSign1.sign(
        protectedHeaders: CoseHeaders.protected(
          mediaType: CoseMediaType.json,
          contentEncoding: CoseHttpContentEncoding.brotli,
          type: CoseDocumentType(CoseUuidV4.fromString(uuidV4)),
          id: CoseDocumentId(CoseUuidV7.fromString(uuidV7)),
          ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7)),
          ref: CoseDocumentRefs([
            CoseDocumentRef.optional(documentId: CoseUuidV7.fromString(uuidV7)),
          ]),
          template: CoseDocumentRefs([
            CoseDocumentRef.optional(documentId: CoseUuidV7.fromString(uuidV7)),
          ]),
          reply: CoseDocumentRefs([
            CoseDocumentRef.optional(documentId: CoseUuidV7.fromString(uuidV7)),
          ]),
          section: const CoseSectionRef(CoseJsonPointer('section_name')),
          collaborators: CoseCollaborators([CatalystIdKid.fromString('test@domain.com')]),
        ),
        unprotectedHeaders: const CoseHeaders.unprotected(),
        signer: signerVerifier,
        payload: utf8.encode('Test payload'),
      );

      // verify whether alg & kid fields were added to protected headers
      expect(coseSign1.protectedHeaders.alg, isNotNull);
      expect(coseSign1.protectedHeaders.kid, isNotEmpty);

      // test whether signature is valid
      final isValid = await coseSign1.verify(verifier: signerVerifier);
      expect(isValid, isTrue);

      // test whether serialization/deserialization works
      final cborValue = coseSign1.toCbor();
      final deserializedCoseSign1 = CoseSign1.fromCbor(cborValue);
      expect(deserializedCoseSign1, equals(deserializedCoseSign1));
    });

    test('incorrectly signed COSE_SIGN1 structure does not validate', () async {
      final coseSign1 = CoseSign1(
        protectedHeaders: const CoseHeaders.protected(),
        unprotectedHeaders: const CoseHeaders.unprotected(),
        payload: utf8.encode('Test payload'),
        signature: Uint8List(64),
      );

      // test whether signature is invalid
      final isValid = await coseSign1.verify(verifier: signerVerifier);
      expect(isValid, isFalse);
    });
  });
}

final class _SignerVerifier implements CatalystCoseSigner, CatalystCoseVerifier {
  final SignatureAlgorithm _algorithm;
  final SimpleKeyPair _keyPair;

  const _SignerVerifier(this._algorithm, this._keyPair);

  @override
  CoseStringOrInt? get alg => const CoseIntValue(CoseValues.eddsaAlg);

  @override
  Future<CatalystIdKid?> get kid async {
    final pk = await _keyPair.extractPublicKey();
    return CatalystIdKid(Uint8List.fromList(pk.bytes));
  }

  @override
  Future<Uint8List> sign(Uint8List data) async {
    final signature = await _algorithm.sign(data, keyPair: _keyPair);
    return Uint8List.fromList(signature.bytes);
  }

  @override
  Future<bool> verify(Uint8List data, Uint8List signature) async {
    final publicKey = await _keyPair.extractPublicKey();
    return _algorithm.verify(
      data,
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(publicKey.bytes, type: KeyPairType.ed25519),
      ),
    );
  }
}
