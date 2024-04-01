import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum Animals {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Dogs')
  dogs('Dogs'),
  @JsonValue('Cats')
  cats('Cats'),
  @JsonValue('Rabbits')
  rabbits('Rabbits');

  final String? value;

  const Animals(this.value);
}

enum Network {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('mainnet')
  mainnet('mainnet'),
  @JsonValue('testnet')
  testnet('testnet'),
  @JsonValue('preprod')
  preprod('preprod'),
  @JsonValue('preview')
  preview('preview');

  final String? value;

  const Network(this.value);
}

enum ReasonRejected {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('FragmentAlreadyInLog')
  fragmentalreadyinlog('FragmentAlreadyInLog'),
  @JsonValue('FragmentInvalid')
  fragmentinvalid('FragmentInvalid'),
  @JsonValue('PreviousFragmentInvalid')
  previousfragmentinvalid('PreviousFragmentInvalid'),
  @JsonValue('PoolOverflow')
  pooloverflow('PoolOverflow');

  final String? value;

  const ReasonRejected(this.value);
}

enum VoterGroupId {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('rep')
  rep('rep'),
  @JsonValue('direct')
  direct('direct');

  final String? value;

  const VoterGroupId(this.value);
}
