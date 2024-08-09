import 'package:cbor/cbor.dart';
import 'package:cryptography/cryptography.dart';

/// A dart plugin implementing CBOR Object Signing and Encryption
/// [RFC-9052](https://datatracker.ietf.org/doc/rfc9052/),
/// [RFC 9053](https://datatracker.ietf.org/doc/rfc9053/).
final class CatalystCose {
  static const int _coseSign1Tag = 18;
  static const int _algKey = 1;
  static const int _kidKey = 4;
  static const int _eddsaAlg = 3;

  CatalystCose._();

  /// Signs the [payload] and returns a [CborValue] representing
  /// a COSE_SIGN1 structure.
  ///
  /// This [kid] parameter identifies one piece of data that can be
  /// used as input to find the needed cryptographic key.
  ///
  /// Limited to EdDSA algorithm with Ed25519 curve.
  static Future<CborValue> sign1({
    required List<int> privateKey,
    required List<int> payload,
    CborValue? kid,
  }) async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(privateKey);

    final protectedHeader = CborBytes(
      cbor.encode(
        CborMap({
          const CborSmallInt(_algKey): const CborSmallInt(_eddsaAlg),
          if (kid != null) const CborSmallInt(_kidKey): kid,
        }),
      ),
    );

    final unprotectedHeader = CborMap({});

    final sigStructure = _createCoseSign1SigStructure(
      protectedHeader: protectedHeader,
      payload: CborBytes(payload),
    );

    final toBeSigned = cbor.encode(
      CborBytes(
        cbor.encode(sigStructure),
      ),
    );

    final signature = await algorithm.sign(
      toBeSigned,
      keyPair: keyPair,
    );

    final coseSign1Structure = CborList(
      [
        protectedHeader,
        unprotectedHeader,
        CborBytes(payload),
        CborBytes(signature.bytes),
      ],
      tags: [_coseSign1Tag],
    );

    return coseSign1Structure;
  }

  /// Verifies whether the given COSE_SIGN1 structure's signature
  /// was created using the provided public key.
  ///
  /// Limited to EdDSA algorithm with Ed25519 curve.
  ///
  /// Returns `true` if the signature is valid, `false` otherwise.
  static Future<bool> verifyCoseSign1({
    required CborValue coseSign1,
    required List<int> publicKey,
  }) async {
    final algorithm = Ed25519();

    if (coseSign1 is! CborList ||
        coseSign1.tags.contains(_coseSign1Tag) != true) {
      return false;
    }

    final cborList = coseSign1;
    if (cborList.length != 4) {
      return false;
    }

    final protectedHeader = cborList[0];
    final unprotectedHeader = cborList[1];
    final payload = cborList[2];
    final signature = cborList[3];

    if (protectedHeader is! CborBytes ||
        unprotectedHeader is! CborMap ||
        payload is! CborBytes ||
        signature is! CborBytes) {
      return false;
    }

    final signatureBytes = signature.bytes;

    final sigStructure = _createCoseSign1SigStructure(
      protectedHeader: protectedHeader,
      payload: payload,
    );

    final toBeSigned = cbor.encode(
      CborBytes(
        cbor.encode(sigStructure),
      ),
    );

    try {
      final verified = await algorithm.verify(
        toBeSigned,
        signature: Signature(
          signatureBytes,
          publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
        ),
      );
      return verified;
    } catch (e) {
      return false;
    }
  }

  static CborValue _createCoseSign1SigStructure({
    required CborValue protectedHeader,
    required CborValue payload,
  }) {
    return CborList([
      // Context text identifying the context of the signature
      CborString('Signature1'),

      // The protected attributes from the body structure
      protectedHeader,

      // External supplied data, empty since not supplied
      CborBytes([]),

      // Payload to be signed
      payload,
    ]);
  }
}
