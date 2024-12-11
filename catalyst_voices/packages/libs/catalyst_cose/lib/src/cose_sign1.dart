import 'dart:typed_data';

import 'package:catalyst_cose/src/cose_constants.dart';
import 'package:catalyst_cose/src/types/cose_headers.dart';
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
  final Uint8List payload;

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
    if (value is! CborList ||
        value.length != 4 ||
        !value.tags.contains(CoseTags.coseSign1)) {
      throw FormatException('$value is not a valid COSE_SIGN1 structure');
    }

    final protectedHeaders = value[0];
    final unprotectedHeaders = value[1];
    final payload = value[2];
    final signature = value[3];

    return CoseSign1(
      protectedHeaders: CoseHeaders.fromCbor(
        protectedHeaders,
        encodeAsBytes: true,
      ),
      unprotectedHeaders: CoseHeaders.fromCbor(
        unprotectedHeaders,
        encodeAsBytes: false,
      ),
      payload: Uint8List.fromList((payload as CborBytes).bytes),
      signature: Uint8List.fromList((signature as CborBytes).bytes),
    );
  }

  /// Creates a signed COSE_SIGN1 structure.
  ///
  /// The [CoseHeaders.alg] parameter in headers must match
  /// the signature algorithm used by the [signer].
  static Future<CoseSign1> sign({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
    required Uint8List payload,
    required CatalystCoseSigner signer,
  }) async {
    final sigStructure = _createCoseSign1SigStructure(
      protectedHeader: protectedHeaders.toCbor(),
      payload: CborBytes(payload),
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
      signature: await signer(toBeSigned),
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
      payload: CborBytes(payload),
    );

    final toBeSigned = cbor.encode(
      CborBytes(
        cbor.encode(sigStructure),
      ),
    );

    try {
      return await verifier(
        Uint8List.fromList(toBeSigned),
        Uint8List.fromList(signature),
      );
    } catch (e) {
      return false;
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList(
      [
        protectedHeaders.toCbor(),
        unprotectedHeaders.toCbor(),
        CborBytes(payload),
        CborBytes(signature),
      ],
      tags: [CoseTags.coseSign1],
    );
  }

  @override
  List<Object?> get props => [
        protectedHeaders,
        unprotectedHeaders,
        payload,
        signature,
      ];

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
