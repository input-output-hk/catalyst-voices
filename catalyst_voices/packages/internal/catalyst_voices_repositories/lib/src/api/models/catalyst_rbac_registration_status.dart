import 'package:json_annotation/json_annotation.dart';

/// Enum to describe the rbac registration status.
@JsonEnum(valueField: 'value')
enum CatalystRbacRegistrationStatus {
  initialized(0),
  notFound(1),
  volatile(2),
  persistent(3);

  final int value;

  const CatalystRbacRegistrationStatus(this.value);
}
