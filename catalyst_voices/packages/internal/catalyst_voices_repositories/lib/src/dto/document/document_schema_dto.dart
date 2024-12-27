import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_definitions_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_dto.g.dart';

// TODO(dtscalac): rewrite this

@JsonSerializable()
class DocumentSchemaDto extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;
  @JsonKey(name: r'$id')
  final String id;
  final String title;
  final String description;
  final DocumentDefinitionsDto definitions;
  final String type;
  final bool additionalProperties;
  @JsonKey(
    toJson: _toJsonProperties,
    fromJson: _fromJsonProperties,
    name: 'properties',
  )
  final List<DocumentSchemaSegmentDto> segments;
  @JsonKey(name: 'x-order')
  final List<String> order;
  @JsonKey(includeToJson: false)
  final String propertiesSchema;

  const DocumentSchemaDto({
    required this.schema,
    required this.id,
    required this.title,
    required this.description,
    required this.definitions,
    this.type = 'object',
    this.additionalProperties = false,
    required this.segments,
    required this.order,
    required this.propertiesSchema,
  });
  factory DocumentSchemaDto.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['propertiesSchema'] =
        (segmentsMap[r'$schema'] as Map<String, dynamic>)['const'];

    return _$DocumentSchemaDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DocumentSchemaDtoToJson(this);

  DocumentSchema toModel() {
    final sortedSegments = List.of(segments)..sortByOrder(order);

    final mappedSegments = sortedSegments
        .where((e) => e.ref.contains('segment'))
        .map(
          (e) => e.toModel(
            definitions.models,
            parentNodeId: DocumentNodeId.root,
          ),
        )
        .toList();

    return DocumentSchema(
      schema: schema,
      title: title,
      description: description,
      segments: mappedSegments,
      order: order,
      propertiesSchema: propertiesSchema,
    );
  }

  @override
  List<Object?> get props => [
        schema,
        title,
        description,
        definitions,
        type,
        additionalProperties,
        segments,
        order,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<DocumentSchemaSegmentDto> segments,
  ) {
    return {
      for (final segment in segments) segment.id: segment.toJson(),
    };
  }

  static List<DocumentSchemaSegmentDto> _fromJsonProperties(
    Map<String, dynamic> json,
  ) {
    final listOfSegments = json.convertMapToListWithIds();
    return listOfSegments.map(DocumentSchemaSegmentDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentSchemaSegmentDto extends Equatable implements Identifiable {
  @JsonKey(name: r'$ref')
  final String ref;
  @override
  final String id;
  final String title;
  final String description;
  @JsonKey(
    toJson: _toJsonProperties,
    fromJson: _fromJsonProperties,
    name: 'properties',
  )
  final List<DocumentSchemaSectionDto> sections;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;

  const DocumentSchemaSegmentDto({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.sections,
    this.required = const <String>[],
    this.order = const <String>[],
  });

  factory DocumentSchemaSegmentDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaSegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaSegmentDtoToJson(this);

  DocumentSchemaSegment toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
  }) {
    final nodeId = parentNodeId.child(id);

    final sortedSections = List.of(sections)..sortByOrder(order);

    final mappedSections = sortedSections
        .where((section) => section.ref.contains('section'))
        .map(
          (e) => e.toModel(
            definitions,
            parentNodeId: nodeId,
            isRequired: required.contains(e.id),
          ),
        )
        .toList();

    return DocumentSchemaSegment(
      definition: definitions.getDefinition(ref),
      nodeId: nodeId,
      id: id,
      title: title,
      description: description,
      sections: mappedSections,
    );
  }

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        sections,
        required,
        order,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<DocumentSchemaSectionDto> sections,
  ) {
    final map = <String, dynamic>{};
    for (final property in sections) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<DocumentSchemaSectionDto> _fromJsonProperties(
    Map<String, dynamic> json,
  ) {
    final listOfSections = json.convertMapToListWithIds();
    return listOfSections.map(DocumentSchemaSectionDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentSchemaSectionDto extends Equatable implements Identifiable {
  @JsonKey(name: r'$ref')
  final String ref;
  @override
  final String id;
  final String title;
  final String description;
  @JsonKey(
    toJson: _toJsonProperties,
    fromJson: _fromJsonProperties,
    name: 'properties',
  )
  final List<DocumentSchemaPropertyDto> properties;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;
  @JsonKey(name: 'if')
  final Map<String, dynamic> ifs;
  final Map<String, dynamic> then; // TODO(dtscalac): Return to this
  @JsonKey(name: 'open_source')
  final Map<String, dynamic> openSource; // TODO(dtscalac): Return to this

  const DocumentSchemaSectionDto({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
    this.ifs = const <String, dynamic>{},
    this.then = const <String, dynamic>{},
    this.openSource = const <String, dynamic>{},
  });

  factory DocumentSchemaSectionDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaSectionDtoToJson(this);

  DocumentSchemaSection toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
    required bool isRequired,
  }) {
    final nodeId = parentNodeId.child(id);

    final sortedProperties = List.of(properties)..sortByOrder(order);

    final mappedProperties = sortedProperties
        .where((property) => BaseDocumentDefinition.isKnownType(property.ref))
        .map((e) => e.toModel(definitions, parentNodeId: nodeId))
        .toList();

    return DocumentSchemaSection(
      definition: definitions.getDefinition(ref),
      nodeId: nodeId,
      id: id,
      title: title,
      description: description,
      properties: mappedProperties,
      isRequired: isRequired,
    );
  }

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        properties,
        required,
        order,
        ifs,
        then,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<DocumentSchemaPropertyDto> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<DocumentSchemaPropertyDto> _fromJsonProperties(
    Map<String, dynamic> json,
  ) {
    final listOfProperties = json.convertMapToListWithIds();
    return listOfProperties.map(DocumentSchemaPropertyDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentSchemaPropertyDto extends Equatable implements Identifiable {
  @JsonKey(name: r'$ref')
  final String ref;
  @override
  final String id;
  final String title;
  final String description;
  @JsonKey(includeIfNull: false)
  final int? minLength;
  @JsonKey(includeIfNull: false)
  final int? maxLength;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @JsonKey(name: 'x-guidance')
  final String guidance;
  @JsonKey(name: 'enum', includeIfNull: false)
  final List<String>? enumValues;
  @JsonKey(includeIfNull: false)
  final int? maxItems;
  @JsonKey(includeIfNull: false)
  final int? minItems;
  @JsonKey(includeIfNull: false)
  final int? minimum;
  @JsonKey(includeIfNull: false)
  final int? maximum;

  // TODO(ryszard-schossler): return to this
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? items;

  const DocumentSchemaPropertyDto({
    this.ref = '',
    required this.id,
    this.title = '',
    this.description = '',
    this.minLength,
    this.maxLength,
    this.defaultValue,
    this.guidance = '',
    this.enumValues,
    this.maxItems,
    this.minItems,
    this.minimum,
    this.maximum,
    this.items,
  });

  factory DocumentSchemaPropertyDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaPropertyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaPropertyDtoToJson(this);

  DocumentSchemaProperty toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
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
    );
  }

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        minLength,
        maxLength,
        defaultValue,
        guidance,
        enumValues,
        maxItems,
        minItems,
        minimum,
        maximum,
      ];
}
