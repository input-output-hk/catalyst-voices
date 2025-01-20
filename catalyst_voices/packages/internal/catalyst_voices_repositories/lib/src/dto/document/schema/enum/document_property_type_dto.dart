import 'package:json_annotation/json_annotation.dart';

enum DocumentPropertyTypeDto {
  array('array'),
  object('object'),
  string('string'),
  integer('integer'),
  number('number'),
  boolean('boolean'),
  nullable('null');

  final String value;

  const DocumentPropertyTypeDto(this.value);

  factory DocumentPropertyTypeDto.fromString(String string) {
    for (final type in values) {
      if (type.value.toLowerCase() == string.toLowerCase()) {
        return type;
      }
    }
    throw ArgumentError('Unsupported $string document property type');
  }
}

final class DocumentPropertyTypeDtoConverter
    extends JsonConverter<List<DocumentPropertyTypeDto>?, Object?> {
  const DocumentPropertyTypeDtoConverter();

  @override
  List<DocumentPropertyTypeDto>? fromJson(Object? json) {
    if (json == null) {
      return null;
    } else if (json is String) {
      return [DocumentPropertyTypeDto.fromString(json)];
    } else if (json is List) {
      final strings = json.cast<String>();
      return strings.map(DocumentPropertyTypeDto.fromString).toList();
    } else {
      throw ArgumentError('Cannot parse $DocumentPropertyTypeDto from $json');
    }
  }

  @override
  Object? toJson(List<DocumentPropertyTypeDto>? object) {
    if (object == null) {
      return null;
    } else if (object.length == 1) {
      return object.first.value;
    } else {
      return object.map((e) => e.value).toList();
    }
  }
}
