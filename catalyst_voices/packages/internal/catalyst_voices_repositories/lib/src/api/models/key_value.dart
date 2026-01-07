import 'package:json_annotation/json_annotation.dart';

part 'key_value.g.dart';

/// A key value for role data.
@JsonSerializable(constructor: '_fromJson')
final class KeyValue {
  /// Ed25519 Public Key
  /// A hex encoded public key.
  final String? pubkey;

  /// A PEM encoded X509 certificate.
  final String? x509;

  /// A hex encoded C509 certificate.
  final String? c509;

  const KeyValue.c509(String this.c509) : pubkey = null, x509 = null;

  factory KeyValue.fromJson(Map<String, dynamic> json) => _$KeyValueFromJson(json);

  const KeyValue.pubkey(String this.pubkey) : x509 = null, c509 = null;

  const KeyValue.x509(String this.x509) : pubkey = null, c509 = null;

  const KeyValue._fromJson({
    this.pubkey,
    this.x509,
    this.c509,
  });

  Map<String, dynamic> toJson() => _$KeyValueToJson(this);
}
