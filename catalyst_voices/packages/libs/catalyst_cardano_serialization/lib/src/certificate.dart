// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/hex.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// Implements a common base of certificate that holds
/// binary [bytes].
abstract base class BaseCertificate implements CborEncodable {
  /// The raw [bytes] of a certificate.
  final List<int> bytes;

  /// Constructs the [BaseCertificate] from raw [bytes].
  const BaseCertificate.fromBytes({required this.bytes});

  /// Deserializes the type from cbor.
  BaseCertificate.fromCbor(CborValue value) : this.fromBytes(bytes: (value as CborBytes).bytes);

  /// Constructs the [BaseCertificate] from a hex string representation
  /// of [bytes].
  BaseCertificate.fromHex(String string) : this.fromBytes(bytes: hexDecode(string));

  @override
  int get hashCode => bytes.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BaseCertificate) return false;

    // prevent subclasses of different types to be equal to each other,
    // even if they hold the same bytes they represent different kinds
    if (other.runtimeType != runtimeType) return false;

    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != other.bytes[i]) return false;
    }

    return true;
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) => CborBytes(bytes, tags: tags);

  /// Returns the hex string representation of [bytes].
  String toHex() => hex.encode(bytes);

  @override
  String toString() => toHex();
}

/// Describes the C509 certificate.
final class C509Certificate extends BaseCertificate {
  /// Constructs the [C509Certificate] from raw [bytes].
  C509Certificate.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  C509Certificate.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [C509Certificate] from a hex string representation
  /// of [bytes].
  C509Certificate.fromHex(super.string) : super.fromHex();
}

/// Describes the X509 certificate encoded in DER format.
final class X509DerCertificate extends BaseCertificate {
  /// Constructs the [X509DerCertificate] from raw [bytes].
  X509DerCertificate.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  X509DerCertificate.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [X509DerCertificate] from a hex string representation
  /// of [bytes].
  X509DerCertificate.fromHex(super.string) : super.fromHex();
}
