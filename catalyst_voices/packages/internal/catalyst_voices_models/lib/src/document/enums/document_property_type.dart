import 'package:json_annotation/json_annotation.dart';

enum DocumentPropertyType {
  @JsonValue('array')
  list,
  @JsonValue('object')
  object,
  @JsonValue('string')
  string,
  @JsonValue('integer')
  integer,
  @JsonValue('number')
  number,
  @JsonValue('boolean')
  boolean,
}
