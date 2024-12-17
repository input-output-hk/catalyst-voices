import 'dart:typed_data';

import 'package:catalyst_cose/src/cose_constants.dart';
import 'package:catalyst_cose/src/types/cose_headers.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// The COSE_SIGN structure implementation, supporting multiple signatures.
///
/// [RFC-9052](https://datatracker.ietf.org/doc/rfc9052/),
/// [RFC 9053](https://datatracker.ietf.org/doc/rfc9053/).
final class CoseSign extends Equatable {
  /// The protected headers that are protected
  /// by the cryptographic [signatures].
  final CoseHeaders protectedHeaders;

  /// The unprotected headers that are not protected by the [signatures].
  final CoseHeaders unprotectedHeaders;

  /// The data that is signed by the [signatures].
  final Uint8List payload;

  /// The cryptographic signatures over
  /// the [protectedHeaders] and the [payload].
  final List<CoseSignature> signatures;

  /// The default constructor for the [CoseSign].
  const CoseSign({
    required this.protectedHeaders,
    required this.unprotectedHeaders,
    required this.payload,
    required this.signatures,
  });

  /// Deserializes the type from cbor.
  factory CoseSign.fromCbor(CborValue value) {
    if (value is! CborList || value.length != 4) {
      throw FormatException('$value is not a valid COSE_SIGN structure');
    }

    final protectedHeaders = value[0];
    final unprotectedHeaders = value[1];
    final payload = value[2];
    final signatures = value[3];

    return CoseSign(
      protectedHeaders: CoseHeaders.fromCbor(
        protectedHeaders,
        encodeAsBytes: true,
      ),
      unprotectedHeaders: CoseHeaders.fromCbor(
        unprotectedHeaders,
        encodeAsBytes: false,
      ),
      payload: Uint8List.fromList((payload as CborBytes).bytes),
      signatures: (signatures as CborList).map(CoseSignature.fromCbor).toList(),
    );
  }

  /// Creates a signed COSE_SIGN structure.
  ///
  /// The [CoseHeaders.alg] parameter in headers must match
  /// the signature algorithm used by the [signers].
  static Future<CoseSign> sign({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
    required Uint8List payload,
    required List<CatalystCoseSigner> signers,
  }) async {
    final signatures = <CoseSignature>[];
    for (final signer in signers) {
      final signatureProtectedHeaders = CoseHeaders.protected(
        alg: signer.alg,
        kid: await signer.kid,
      );

      final toBeSigned = _createCoseSignSigStructureBytes(
        bodyProtectedHeaders: protectedHeaders,
        signatureProtectedHeaders: signatureProtectedHeaders,
        payload: payload,
      );

      final signature = CoseSignature(
        protectedHeaders: signatureProtectedHeaders,
        unprotectedHeaders: const CoseHeaders.unprotected(),
        signature: await signer.sign(toBeSigned),
      );

      signatures.add(signature);
    }

    return CoseSign(
      protectedHeaders: protectedHeaders,
      unprotectedHeaders: unprotectedHeaders,
      payload: payload,
      signatures: signatures,
    );
  }

  /// Verifies whether the COSE_SIGN signature is valid.
  ///
  /// The signature is selected from the list of [signatures] based on the kid].
  /// The [verifier] is responsible for providing the verification algorithm.
  Future<bool> verify({
    required CatalystCoseVerifier verifier,
  }) async {
    for (final signature in signatures) {
      if (signature.protectedHeaders.kid == await verifier.kid) {
        final toBeSigned = _createCoseSignSigStructureBytes(
          bodyProtectedHeaders: protectedHeaders,
          signatureProtectedHeaders: signature.protectedHeaders,
          payload: payload,
        );
        return verifier.verify(toBeSigned, signature.signature);
      }
    }

    // no eligible signature found that would match the kid
    return false;
  }

  /// Verifies whether the COSE_SIGN [signatures] are valid.
  ///
  /// The [verifiers] are responsible for providing the verification algorithm.
  Future<bool> verifyAll({
    required List<CatalystCoseVerifier> verifiers,
  }) async {
    for (final verifier in verifiers) {
      final isVerified = await verify(verifier: verifier);
      if (!isVerified) {
        return false;
      }
    }

    return true;
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList(
      [
        protectedHeaders.toCbor(),
        unprotectedHeaders.toCbor(),
        CborBytes(payload),
        CborList([
          for (final signature in signatures) signature.toCbor(),
        ]),
      ],
      tags: [CoseTags.coseSign],
    );
  }

  @override
  List<Object?> get props => [
        protectedHeaders,
        unprotectedHeaders,
        payload,
        signatures,
      ];

  static Uint8List _createCoseSignSigStructureBytes({
    required CoseHeaders bodyProtectedHeaders,
    required CoseHeaders signatureProtectedHeaders,
    required Uint8List payload,
  }) {
    final sigStructure = _createCoseSignSigStructure(
      bodyProtectedHeaders: bodyProtectedHeaders.toCbor(),
      signatureProtectedHeaders: signatureProtectedHeaders.toCbor(),
      payload: CborBytes(payload),
    );

    return Uint8List.fromList(
      cbor.encode(
        CborBytes(
          cbor.encode(sigStructure),
        ),
      ),
    );
  }

  static CborList _createCoseSignSigStructure({
    required CborValue bodyProtectedHeaders,
    required CborValue signatureProtectedHeaders,
    required CborValue payload,
  }) {
    return CborList([
      // Context text identifying the context of the signature
      CborString('Signature'),

      // The protected attributes from the body structure
      bodyProtectedHeaders,

      // The protected attributes from the signature structure
      signatureProtectedHeaders,

      // External supplied data, empty since not supplied
      CborBytes([]),

      // Payload to be signed
      payload,
    ]);
  }
}

/// The signature of the COSE_SIGN structure.
final class CoseSignature extends Equatable {
  /// The protected headers that are protected by the cryptographic [signature].
  final CoseHeaders protectedHeaders;

  /// The unprotected headers that are not protected by the [signature].
  final CoseHeaders unprotectedHeaders;

  /// The cryptographic signature over the [protectedHeaders] and the payload.
  final Uint8List signature;

  /// The default constructor for the [CoseSignature].
  const CoseSignature({
    required this.protectedHeaders,
    required this.unprotectedHeaders,
    required this.signature,
  });

  /// Deserializes the type from cbor.
  factory CoseSignature.fromCbor(CborValue value) {
    final list = value as CborList;

    final protectedHeaders = list[0];
    final unprotectedHeaders = list[1];
    final signature = list[2];

    return CoseSignature(
      protectedHeaders: CoseHeaders.fromCbor(
        protectedHeaders,
        encodeAsBytes: true,
      ),
      unprotectedHeaders: CoseHeaders.fromCbor(
        unprotectedHeaders,
        encodeAsBytes: false,
      ),
      signature: Uint8List.fromList((signature as CborBytes).bytes),
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      protectedHeaders.toCbor(),
      unprotectedHeaders.toCbor(),
      CborBytes(signature),
    ]);
  }

  @override
  List<Object?> get props => [
        protectedHeaders,
        unprotectedHeaders,
        signature,
      ];
}
