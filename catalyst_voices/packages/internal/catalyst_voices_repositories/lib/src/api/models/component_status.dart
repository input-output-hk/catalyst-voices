import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ComponentStatus {
  operational('OPERATIONAL'),
  partialOutage('PARTIALOUTAGE'),
  minorOutage('MINOROUTAGE'),
  majorOutage('MAJOROUTAGE');

  final String value;

  const ComponentStatus(this.value);
}
