import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_property_dto.g.dart';

@JsonSerializable()
final class DocumentSchemaPropertyDto {
  @JsonKey(name: r'$ref')
  final String ref;
  @JsonKey(includeToJson: false)
  final String id;
  final String? title;
  final String? description;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @JsonKey(name: 'x-guidance')
  final String? guidance;
  @JsonKey(name: 'enum', includeIfNull: false)
  final List<String>? enumValues;
  @JsonKey(includeIfNull: false)
  final int? minimum;
  @JsonKey(includeIfNull: false)
  final int? maximum;
  @JsonKey(includeIfNull: false)
  final int? minLength;
  @JsonKey(includeIfNull: false)
  final int? maxLength;
  @JsonKey(includeIfNull: false)
  final int? minItems;
  @JsonKey(includeIfNull: false)
  final int? maxItems;

  // TODO(ryszard-schossler): return to this
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? items;

  const DocumentSchemaPropertyDto({
    this.ref = '',
    required this.id,
    this.title,
    this.description,
    this.defaultValue,
    this.guidance,
    this.enumValues,
    this.minimum,
    this.maximum,
    this.minLength,
    this.maxLength,
    this.maxItems,
    this.minItems,
    this.items,
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
      numRange: Range.optionalRangeOf(min: minimum, max: maximum),
      strRange: Range.optionalRangeOf(min: minLength, max: maxLength),
      itemsRange: Range.optionalRangeOf(min: minItems, max: maxItems),
      isRequired: isRequired,
    );
  }
}
