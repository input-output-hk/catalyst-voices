import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_converter_ext.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_logical_property_dto.dart';
import 'package:catalyst_voices_repositories/src/utils/document_schema_dto_converter.dart';
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
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @JsonKey(name: 'x-guidance')
  final String? guidance;
  @JsonKey(name: 'enum')
  final List<String>? enumValues;
  @DocumentSchemaPropertiesDtoConverter()
  final List<DocumentSchemaPropertyDto> properties;
  final DocumentSchemaPropertyDto? items;
  final int? minimum;
  final int? maximum;
  final int? minLength;
  final int? maxLength;
  final int? minItems;
  final int? maxItems;

  /// Logical boolean algebra conditions.
  final List<DocumentSchemaLogicalGroupDto>? oneOf;

  /// The list of required [properties].
  final List<String>? required;

  /// The order of children [properties].
  @JsonKey(name: 'x-order')
  final List<String>? order;

  const DocumentSchemaPropertyDto({
    this.ref = '',
    required this.id,
    this.title,
    this.description,
    this.defaultValue,
    this.guidance,
    this.enumValues,
    this.properties = const [],
    this.items,
    this.minimum,
    this.maximum,
    this.minLength,
    this.maxLength,
    this.maxItems,
    this.minItems,
    this.oneOf,
    this.required,
    this.order,
  });

  factory DocumentSchemaPropertyDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaPropertyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaPropertyDtoToJson(this);

  DocumentPropertySchema toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
    required bool isRequired,
  }) {
    final definition = definitions.getDefinition(ref);
    final nodeId = parentNodeId.child(id);
    final required = this.required ?? const [];
    final order = this.order ?? const [];

    return definition.createSchema(
      nodeId: nodeId,
      id: id,
      title: title,
      description: description,
      defaultValue: definition.converter.fromJson(defaultValue),
      guidance: guidance,
      enumValues: enumValues,
      properties: properties
          .map(
            (e) => e.toModel(
              definitions,
              parentNodeId: nodeId,
              isRequired: required.contains(e.id),
            ),
          )
          .toList(),
      items: items?.toModel(
        definitions,
        parentNodeId: nodeId,
        isRequired: false,
      ),
      numRange: Range.optionalIntRangeOf(min: minimum, max: maximum),
      strLengthRange: Range.optionalIntRangeOf(min: minLength, max: maxLength),
      itemsRange: Range.optionalIntRangeOf(min: minItems, max: maxItems),
      oneOf: oneOf?.map((e) => e.toModel(definitions)).toList(),
      isRequired: isRequired,
      order: order.map(nodeId.child).toList(),
    );
  }
}
