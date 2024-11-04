import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum DeepQueryInspectionFlag {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('enabled')
  enabled('enabled'),
  @JsonValue('disabled')
  disabled('disabled');

  final String? value;

  const DeepQueryInspectionFlag(this.value);
}

enum LogLevel {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('debug')
  debug('debug'),
  @JsonValue('info')
  info('info'),
  @JsonValue('warn')
  warn('warn'),
  @JsonValue('error')
  error('error');

  final String? value;

  const LogLevel(this.value);
}

enum Network {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('mainnet')
  mainnet('mainnet'),
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

enum VotingInfoDelegationsType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Delegated')
  delegated('Delegated');

  final String? value;

  const VotingInfoDelegationsType(this.value);
}

enum VotingInfoDirectVoterType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Direct')
  direct('Direct');

  final String? value;

  const VotingInfoDirectVoterType(this.value);
}
