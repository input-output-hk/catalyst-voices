import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/mapper/document_boolean_schema_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/mapper/document_integer_schema_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/mapper/document_list_schema_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/mapper/document_number_schema_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/mapper/document_object_schema_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/mapper/document_string_schema_mapper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_property_schema_dto.g.dart';

@JsonSerializable(includeIfNull: false)
final class DocumentPropertySchemaDto {
  @JsonKey(name: r'$ref')
  final String? ref;
  final DocumentPropertyType? type;
  final String? title;
  final String? description;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @JsonKey(name: 'x-guidance')
  final String? guidance;
  @JsonKey(name: 'const')
  final Object? constValue;
  @JsonKey(name: 'enum')
  final List<Object>? enumValues;
  final Map<String, DocumentPropertySchemaDto>? properties;
  final DocumentPropertySchemaDto? items;
  final int? minimum;
  final int? maximum;
  final int? minLength;
  final int? maxLength;
  final int? minItems;
  final int? maxItems;

  /// Logical boolean algebra conditions.
  final List<DocumentPropertySchemaDto>? oneOf;

  /// The list of required [properties].
  final List<String>? required;

  /// The order of children [properties].
  @JsonKey(name: 'x-order')
  final List<String>? order;

  const DocumentPropertySchemaDto({
    this.ref,
    this.type,
    this.title,
    this.description,
    this.defaultValue,
    this.guidance,
    this.constValue,
    this.enumValues,
    this.properties,
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

  factory DocumentPropertySchemaDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentPropertySchemaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentPropertySchemaDtoToJson(this);

  DocumentPropertySchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final definition = definitions.getDefinition(ref);
    final schema = definition != null ? mergeWith(definition) : this;

    switch (schema.type!) {
      case DocumentPropertyType.list:
        return DocumentListSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequired,
        );
      case DocumentPropertyType.object:
        return DocumentObjectSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequired,
        );
      case DocumentPropertyType.string:
        return DocumentStringSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequired,
        );
      case DocumentPropertyType.integer:
        return DocumentIntegerSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequired,
        );
      case DocumentPropertyType.number:
        return DocumentNumberSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequired,
        );
      case DocumentPropertyType.boolean:
        return DocumentBooleanSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequired,
        );
    }
  }

  DocumentSchemaLogicalGroup toLogicalGroup({
    required DocumentDefinitionsDto definitions,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final properties = this.properties?.values ?? [];

    return DocumentSchemaLogicalGroup(
      conditions: [
        for (final property in properties)
          property.toLogicalCondition(
            definitions: definitions,
            nodeId: nodeId,
            isRequired: isRequired,
          ),
      ],
    );
  }

  DocumentSchemaLogicalCondition toLogicalCondition({
    required DocumentDefinitionsDto definitions,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final definition = definitions.getDefinition(ref);
    final schema = definition != null ? mergeWith(definition) : this;

    return DocumentSchemaLogicalCondition(
      schema: schema.toModel(
        definitions: definitions,
        nodeId: nodeId,
        isRequired: isRequired,
      ),
      constValue: constValue,
      enumValues: enumValues,
    );
  }

  /// Returns a new copy of the [DocumentPropertySchemaDto],
  /// fields from this and [other] instance are merged into a single instance.
  ///
  /// Fields from this instance have more priority
  /// (in case they appear in both instances).
  DocumentPropertySchemaDto mergeWith(DocumentPropertySchemaDto other) {
    return DocumentPropertySchemaDto(
      ref: ref ?? other.ref,
      type: type ?? other.type,
      title: title ?? other.title,
      description: description ?? other.description,
      defaultValue: defaultValue ?? other.defaultValue,
      properties: properties ?? other.properties,
      items: items ?? other.items,
      minimum: minimum ?? other.minimum,
      maximum: maximum ?? other.maximum,
      minLength: minLength ?? other.minLength,
      maxLength: maxLength ?? other.maxLength,
      minItems: minItems ?? other.minItems,
      maxItems: maxItems ?? other.maxItems,
      oneOf: oneOf ?? other.oneOf,
      required: required ?? other.required,
      order: order ?? other.order,
    );
  }

  String? definition() {
    final ref = this.ref;
    if (ref == null) {
      return null;
    }

    final index = ref.lastIndexOf('/');
    return ref.substring(index);
  }
}
