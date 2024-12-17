import 'dart:typed_data';

import 'package:catalyst_cose/src/types/string_or_int.dart';
import 'package:cbor/cbor.dart';

/// Holds commonly used tags in COSE.
///
/// Defined in [RFC-9052](https://datatracker.ietf.org/doc/rfc9052).
abstract final class CoseTags {
  /// The tag that describes a COSE_SIGN1 structure.
  static const int coseSign1 = 18;

  /// The tags that describes a COSE_SIGN structure.
  static const int coseSign = 98;
}

/// Holds commonly used keys for protected/unprotected headers in COSE.
final class CoseHeaderKeys {
  const CoseHeaderKeys._();

  /// The header key describing the signature algorithm.
  static const alg = CborSmallInt(1);

  /// The header key describing the content-type of the payload.
  static const contentType = CborSmallInt(3);

  /// The header key describing the key identifier.
  static const kid = CborSmallInt(4);

  /// The header key for "content encoding".
  static final contentEncoding = CborString('content encoding');

  /// The header key for "type".
  static final type = CborString('type');

  /// The header key for "id".
  static final id = CborString('id');

  /// The header key for "ver".
  static final ver = CborString('ver');

  /// The header key for "ref".
  static final ref = CborString('ref');

  /// The header key for "template".
  static final template = CborString('template');

  /// The header key for "reply".
  static final reply = CborString('reply');

  /// The header key for "section".
  static final section = CborString('section');

  /// The header key for "collabs".
  static final collabs = CborString('collabs');
}

/// Holds commonly used keys for protected/unprotected headers in COSE.
final class CoseValues {
  const CoseValues._();

  /// The Edwards-Curve Digital Signature Algorithm (EdDSA).
  static const eddsaAlg = -8;

  /// The json content type value.
  static const jsonContentType = 30;

  /// The brotli compression content encoding.
  static const brotliContentEncoding = 'br';
}

/// The interface for the data signer callback.
// ignore: one_member_abstracts
abstract interface class CatalystCoseSigner {
  /// Returns the alg identifier that should refer
  /// to the cryptographic algorithm used to [sign] the data.
  StringOrInt? get alg;

  /// Returns a key identifier that typically should refer to the public key
  /// of the private key used to sign the data.
  Future<String?> get kid;

  /// The [data] should be signed with a private key
  /// and the resulting signature returned as [Uint8List].
  Future<Uint8List> sign(Uint8List data);
}

/// The interface for the signature verifier callback.
// ignore: one_member_abstracts
abstract interface class CatalystCoseVerifier {
  /// Returns a key identifier that typically should refer to the public key
  /// of the private key used to sign the data.
  Future<String?> get kid;

  /// The [signature] should be verified against
  /// a known public/private key over the [data].
  Future<bool> verify(Uint8List data, Uint8List signature);
}
