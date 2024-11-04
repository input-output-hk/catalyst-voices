import 'dart:convert';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:ulid/ulid.dart';

/// The Authentication Token is based loosely on JWT.
/// It consists of an Authentication Header attached to every authenticated
/// request, and an encoded signed.
///
/// This token can be attached to either individual HTTP requests,
/// or to the beginning of a web socket connection.
///
/// The authentication header is in the format:
///
/// ```http
/// Authorization: Bearer catv1.<encoded token>
/// ```
///
/// ### Encoded Binary Token Format
///
/// The Encoded Binary Token is a [CBOR sequence] that consists of 3 fields.
///
/// * `kid` : The key identifier.
/// * `ulid` : A ULID which defines when the token was issued,
/// and a random nonce.
/// * `signature` : The signature over the `kid` and `ulid` fields.
final class AuthToken {
  /// The token prefix which distinguishes this auth token from other
  /// auth tokens and allows version via the v{} part.
  static const String prefix = 'catv1';

  /// Prevent creating instances.
  const AuthToken._();

  /// Generates a new auth token at a given [timestamp].
  ///
  /// * The [kid] in most cases is going to be a [CertificateHash]
  /// of the [privateKey] certificate.
  /// * The [privateKey] must correspond to the [kid] specified.
  /// * The [timestamp] is a [DateTime] when a given token has been generated.
  static Future<String> generate({
    required CertificateHash kid,
    required Ed25519PrivateKey privateKey,
    required DateTime timestamp,
  }) async {
    final ulid = CborBytes(
      Ulid(millis: timestamp.millisecondsSinceEpoch).toBytes(),
    );

    final toBeSigned = [
      ...cbor.encode(kid.toCbor()),
      ...cbor.encode(ulid),
    ];

    final signature = await privateKey.sign(toBeSigned);

    final cborToken = [
      ...cbor.encode(kid.toCbor()),
      ...cbor.encode(ulid),
      ...cbor.encode(signature.toCbor()),
    ];

    final base64Token = base64Encode(cborToken);
    return '$prefix.$base64Token';
  }
}
