import 'dart:typed_data';

import 'package:catalyst_cose/src/cose_constants.dart';
import 'package:catalyst_cose/src/exception/cose_exception.dart';
import 'package:catalyst_cose/src/exception/cose_format_exception.dart';
import 'package:catalyst_cose/src/types/cose_headers.dart';
import 'package:catalyst_cose/src/types/cose_payload.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// The COSE_SIGN1 structure implementation, supporting a single signature.
///
/// [RFC-9052](https://datatracker.ietf.org/doc/rfc9052/),
/// [RFC 9053](https://datatracker.ietf.org/doc/rfc9053/).
final class CoseSign1 extends Equatable {
  /// The protected headers that are protected by the cryptographic [signature].
  final CoseHeaders protectedHeaders;

  /// The unprotected headers that are not protected by the [signature].
  final CoseHeaders unprotectedHeaders;

  /// The data that is signed by the [signature].
  final CosePayload payload;

  /// The cryptographic signature over the [protectedHeaders] and the [payload].
  final Uint8List signature;

  /// The default constructor for the [CoseSign1].
  const CoseSign1({
    required this.protectedHeaders,
    required this.unprotectedHeaders,
    required this.payload,
    required this.signature,
  });

  /// Deserializes the type from cbor.
  factory CoseSign1.fromCbor(CborValue value) {
    if (value is! CborList || value.length != 4) {
      throw CoseFormatException('$value is not a valid COSE_SIGN1 structure');
    }

    final protectedHeaders = value[0];
    final unprotectedHeaders = value[1];
    final payload = value[2];
    final signature = value[3];

    return CoseSign1(
      protectedHeaders: CoseHeaders.fromCbor(
        protectedHeaders,
      ),
      unprotectedHeaders: CoseHeaders.fromCbor(
        unprotectedHeaders,
        encodeAsBytes: false,
      ),
      payload: CosePayload.fromCbor(payload),
      signature: Uint8List.fromList((signature as CborBytes).bytes),
    );
  }

  @override
  List<Object?> get props => [
    protectedHeaders,
    unprotectedHeaders,
    payload,
    signature,
  ];

  /// Serializes the type as cbor.
  CborValue toCbor({bool tagged = true}) {
    return CborList(
      [
        protectedHeaders.toCbor(),
        unprotectedHeaders.toCbor(),
        payload.toCbor(),
        CborBytes(signature),
      ],
      tags: [
        if (tagged) CoseTags.coseSign1,
      ],
    );
  }

  /// Verifies whether the COSE_SIGN1 [signature] is valid.
  ///
  /// The [verifier] is responsible for providing the verification algorithm.
  Future<bool> verify({
    required CatalystCoseVerifier verifier,
  }) async {
    final sigStructure = _createCoseSign1SigStructure(
      protectedHeader: protectedHeaders.toCbor(),
      payload: payload.toCbor(),
    );

    final toBeSigned = cbor.encode(
      CborBytes(
        cbor.encode(sigStructure),
      ),
    );

    try {
      return await verifier.verify(
        Uint8List.fromList(toBeSigned),
        Uint8List.fromList(signature),
      );
    } catch (e) {
      return false;
    }
  }

  /// Creates a signed COSE_SIGN1 structure.
  ///
  /// The [CoseHeaders.alg] parameter in headers must match
  /// the signature algorithm used by the [signer].
  static Future<CoseSign1> sign({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
    required CosePayload payload,
    required CatalystCoseSigner signer,
  }) async {
    try {
      final kid = await signer.kid;

      protectedHeaders = protectedHeaders.copyWith(
        alg: () => signer.alg,
        kid: () => kid,
      );

      final sigStructure = _createCoseSign1SigStructure(
        protectedHeader: protectedHeaders.toCbor(),
        payload: payload.toCbor(),
      );

      final toBeSigned = Uint8List.fromList(
        cbor.encode(
          CborBytes(
            cbor.encode(sigStructure),
          ),
        ),
      );

      return CoseSign1(
        protectedHeaders: protectedHeaders,
        unprotectedHeaders: unprotectedHeaders,
        payload: payload,
        signature: await signer.sign(toBeSigned),
      );
    } catch (error) {
      throw CoseSignException(
        message: 'Failed to create a CoseSign1 instance',
        source: error,
      );
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
