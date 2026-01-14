import 'package:json_annotation/json_annotation.dart';

/// Cardano network type.
///
/// Used as query parameter for GET /v1/cardano/assets/{stake_address}.
@JsonEnum(valueField: 'value')
enum Network {
  mainnet('mainnet'),
  preprod('preprod'),
  preview('preview');

  final String value;

  const Network(this.value);
}
