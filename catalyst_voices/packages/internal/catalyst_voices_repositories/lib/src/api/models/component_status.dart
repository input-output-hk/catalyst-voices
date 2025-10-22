import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ComponentStatus {
  /* cSpell:disable */
  operational('OPERATIONAL'),
  partialOutage('PARTIALOUTAGE'),
  minorOutage('MINOROUTAGE'),
  majorOutage('MAJOROUTAGE');
  /* cSpell:enable */

  final String value;

  const ComponentStatus(this.value);
}
