import 'package:json_annotation/json_annotation.dart';

/// A key type for role data.
@JsonEnum(valueField: 'value')
enum KeyType {
  pubkey('pubkey'),
  x509('x509'),
  c509('c509');

  final String value;

  const KeyType(this.value);
}
