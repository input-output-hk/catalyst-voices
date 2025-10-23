import 'package:json_annotation/json_annotation.dart';

/// Enum to describe the catalyst_id status.
@JsonEnum(valueField: 'value')
enum CatalystIdStatus {
  inactive(0),
  emailVerified(1),
  active(2),
  banned(3);

  final int value;

  const CatalystIdStatus(this.value);
}
