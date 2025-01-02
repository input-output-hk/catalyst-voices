import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_logical_property_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_property_dto.g.dart';

@JsonSerializable(includeIfNull: false)
final class DocumentSchemaPropertyDto {
  @JsonKey(name: r'$ref')
  final String ref;
  @JsonKey(includeToJson: false)
  final String id;
  final String? title;
  final String? description;
  final int? minLength;
  final int? maxLength;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @JsonKey(name: 'x-guidance')
  final String? guidance;
  @JsonKey(name: 'enum')
  final List<String>? enumValues;
  final int? maxItems;
  final int? minItems;
  final int? minimum;
  final int? maximum;

  // TODO(ryszard-schossler): return to this
  final Map<String, dynamic>? items;

  // Logical boolean algebra conditions
  final List<DocumentSchemaLogicalGroupDto>? oneOf;

  const DocumentSchemaPropertyDto({
    this.ref = '',
    required this.id,
    this.title,
    this.description,
    this.minLength,
    this.maxLength,
    this.defaultValue,
    this.guidance,
    this.enumValues,
    this.maxItems,
    this.minItems,
    this.minimum,
    this.maximum,
    this.items,
    this.oneOf,
  });

  factory DocumentSchemaPropertyDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaPropertyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaPropertyDtoToJson(this);

  DocumentSchemaProperty toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
    required bool isRequired,
  }) {
    return DocumentSchemaProperty(
      definition: definitions.getDefinition(ref),
      nodeId: parentNodeId.child(id),
      id: id,
      title: title,
      description: description,
      defaultValue: defaultValue,
      guidance: guidance,
      enumValues: enumValues,
      range: Range.optionalRangeOf(min: minimum, max: maximum),
      itemsRange: Range.optionalRangeOf(min: minItems, max: maxItems),
      oneOf: oneOf?.map((e) => e.toModel(definitions)).toList(),
      isRequired: isRequired,
    );
  }
}
