import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/utils/document_schema_dto_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_logical_property_dto.g.dart';

@JsonSerializable(includeIfNull: false)
final class DocumentSchemaLogicalGroupDto {
  @DocumentSchemaLogicalPropertiesDtoConverter()
  @JsonKey(name: 'properties')
  final List<DocumentSchemaLogicalConditionDto>? conditions;

  DocumentSchemaLogicalGroupDto({
    this.conditions,
  });

  factory DocumentSchemaLogicalGroupDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return _$DocumentSchemaLogicalGroupDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DocumentSchemaLogicalGroupDtoToJson(this);
  }

  DocumentSchemaLogicalGroup toModel(
    List<BaseDocumentDefinition> definitions,
  ) {
    final conditions = this.conditions ?? const [];

    return DocumentSchemaLogicalGroup(
      conditions: conditions.map((e) => e.toModel(definitions)).toList(),
    );
  }
}

@JsonSerializable(includeIfNull: false)
final class DocumentSchemaLogicalConditionDto {
  @JsonKey(name: r'$ref')
  final String ref;
  @JsonKey(includeToJson: false)
  final String id;
  @JsonKey(name: 'const')
  final Object? value;
  @JsonKey(name: 'enum')
  final List<String>? enumValues;

  const DocumentSchemaLogicalConditionDto({
    this.ref = '',
    required this.id,
    this.value,
    this.enumValues,
  });

  factory DocumentSchemaLogicalConditionDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return _$DocumentSchemaLogicalConditionDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DocumentSchemaLogicalConditionDtoToJson(this);
  }

  DocumentSchemaLogicalCondition toModel(
    List<BaseDocumentDefinition> definitions,
  ) {
    return DocumentSchemaLogicalCondition(
      definition: definitions.getDefinition(ref),
      id: id,
      value: value,
      enumValues: enumValues,
    );
  }
}
