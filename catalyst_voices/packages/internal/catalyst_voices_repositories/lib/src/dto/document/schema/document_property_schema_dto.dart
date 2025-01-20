import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/enum/document_property_type_dto.dart';
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
  @JsonKey(name: 'type')
  @DocumentPropertyTypeDtoConverter()
  final List<DocumentPropertyTypeDto>? types;
  final String? format;
  final String? contentMediaType;
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
  final String? pattern;

  /// Logical boolean algebra conditions.
  final List<DocumentPropertySchemaDto>? oneOf;

  /// The list of required [properties].
  final List<String>? required;

  /// The order of children [properties].
  @JsonKey(name: 'x-order')
  final List<String>? order;

  const DocumentPropertySchemaDto({
    required this.ref,
    required this.types,
    required this.format,
    required this.contentMediaType,
    required this.title,
    required this.description,
    required this.defaultValue,
    required this.guidance,
    required this.constValue,
    required this.enumValues,
    required this.properties,
    required this.items,
    required this.minimum,
    required this.maximum,
    required this.minLength,
    required this.maxLength,
    required this.maxItems,
    required this.minItems,
    required this.oneOf,
    required this.required,
    required this.order,
    required this.pattern,
  });

  const DocumentPropertySchemaDto.optional({
    this.ref,
    this.types,
    this.format,
    this.contentMediaType,
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
    this.pattern,
  });

  factory DocumentPropertySchemaDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentPropertySchemaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentPropertySchemaDtoToJson(this);

  DocumentPropertySchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final definitionSchema = definitions.getDefinition(definition());
    final schema =
        definitionSchema != null ? mergeWith(definitionSchema) : this;
    final types = schema.types ?? [];
    final isRequiredAndNonNullable =
        isRequired && !types.contains(DocumentPropertyTypeDto.nullable);

    final type = types.firstWhere(
      (e) => e != DocumentPropertyTypeDto.nullable,
      orElse: () =>
          throw ArgumentError('Property type cannot be empty or nullable'),
    );

    switch (type) {
      case DocumentPropertyTypeDto.array:
        return DocumentListSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequiredAndNonNullable,
        );
      case DocumentPropertyTypeDto.object:
        return DocumentObjectSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequiredAndNonNullable,
        );
      case DocumentPropertyTypeDto.string:
        return DocumentStringSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequiredAndNonNullable,
        );
      case DocumentPropertyTypeDto.integer:
        return DocumentIntegerSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequiredAndNonNullable,
        );
      case DocumentPropertyTypeDto.number:
        return DocumentNumberSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequiredAndNonNullable,
        );
      case DocumentPropertyTypeDto.boolean:
        return DocumentBooleanSchemaMapper.toModel(
          definitions: definitions,
          schema: schema,
          nodeId: nodeId,
          isRequired: isRequiredAndNonNullable,
        );
      case DocumentPropertyTypeDto.nullable:
        throw ArgumentError('The primary property type cannot be "null".');
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
  /// Fields from this instance have more priority than from the
  /// [other] instance (in case they appear in both instances).
  DocumentPropertySchemaDto mergeWith(DocumentPropertySchemaDto other) {
    final mergedItems = _mergeItems(items, other.items);
    final mergedOneOf = oneOf ?? other.oneOf;

    var mergedProperties = _mergeProperties(properties, other.properties);
    if (mergedOneOf != null) {
      for (final item in mergedOneOf) {
        mergedProperties = _mergeProperties(mergedProperties, item.properties);
      }
    }

    return DocumentPropertySchemaDto(
      ref: ref ?? other.ref,
      types: types ?? other.types,
      format: format ?? other.format,
      contentMediaType: contentMediaType ?? other.contentMediaType,
      title: title ?? other.title,
      description: description ?? other.description,
      defaultValue: defaultValue ?? other.defaultValue,
      guidance: guidance ?? other.guidance,
      constValue: constValue ?? other.constValue,
      enumValues: enumValues ?? other.enumValues,
      properties: mergedProperties,
      items: mergedItems,
      minimum: minimum ?? other.minimum,
      maximum: maximum ?? other.maximum,
      minLength: minLength ?? other.minLength,
      maxLength: maxLength ?? other.maxLength,
      minItems: minItems ?? other.minItems,
      maxItems: maxItems ?? other.maxItems,
      oneOf: oneOf ?? other.oneOf,
      required: required ?? other.required,
      order: order ?? other.order,
      pattern: pattern ?? other.pattern,
    );
  }

  DocumentPropertySchemaDto? _mergeItems(
    DocumentPropertySchemaDto? first,
    DocumentPropertySchemaDto? second,
  ) {
    if (first == null || second == null) {
      return first ?? second;
    } else {
      return first.mergeWith(second);
    }
  }

  Map<String, DocumentPropertySchemaDto>? _mergeProperties(
    Map<String, DocumentPropertySchemaDto>? first,
    Map<String, DocumentPropertySchemaDto>? second,
  ) {
    if (first == null || second == null) {
      return first ?? second;
    }

    final map = Map.of(first);
    for (final entry in second.entries) {
      final firstEntry = map[entry.key];
      if (firstEntry != null) {
        map[entry.key] = firstEntry.mergeWith(entry.value);
      } else {
        map[entry.key] = entry.value;
      }
    }

    return map;
  }

  String? definition() {
    final ref = this.ref;
    if (ref == null) {
      return null;
    }

    final index = ref.lastIndexOf('/');
    if (index < 0) {
      return null;
    }

    return ref.substring(index + 1);
  }
}
