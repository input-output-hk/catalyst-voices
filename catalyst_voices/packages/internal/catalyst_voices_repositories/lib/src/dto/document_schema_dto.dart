import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document_definitions_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_dto.g.dart';

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

  static late Map<String, int> orderMap;

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
    json['propertiesDocumentSchema'] =
        (segmentsMap[r'$schema'] as Map<String, dynamic>)['const'];

    return _$DocumentSchemaDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DocumentSchemaDtoToJson(this);

  DocumentSchema toModel() {
    orderMap = {for (var i = 0; i < order.length; i++) order[i]: i};
    final sortedProperties = List<DocumentSchemaSegmentDto>.from(this.segments)
      ..sort();
    final segments = sortedProperties
        .where((e) => e.ref.contains('segment'))
        .map((e) => e.toModel(definitions.definitionsModels))
        .toList();
    return DocumentSchema(
      schema: schema,
      title: title,
      description: description,
      segments: segments,
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
    final map = <String, dynamic>{};
    for (final property in segments) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<DocumentSchemaSegmentDto> _fromJsonProperties(
    Map<String, dynamic> json,
  ) {
    final listOfSegments = json.convertMapToListWithIds();
    return listOfSegments.map(DocumentSchemaSegmentDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentSchemaSegmentDto extends Equatable
    implements Comparable<DocumentSchemaSegmentDto> {
  @JsonKey(name: r'$ref')
  final String ref;
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

  static late Map<String, int> orderMap;

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

  DocumentSchemaSegment toModel(List<BaseDocumentDefinition> definitions) {
    orderMap = {for (var i = 0; i < order.length; i++) order[i]: i};
    final sortedProperties = List<DocumentSchemaSectionDto>.from(this.sections)
      ..sort();
    final sections = sortedProperties
        .where((element) => element.ref.contains('section'))
        .map((e) => e.toModel(definitions, isRequired: required.contains(e.id)))
        .toList();
    return DocumentSchemaSegment(
      ref: definitions.getDefinition(ref),
      id: id,
      title: title,
      description: description,
      sections: sections,
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

  @override
  int compareTo(DocumentSchemaSegmentDto other) {
    final thisIndex =
        DocumentSchemaDto.orderMap[id] ?? double.maxFinite.toInt();
    final otherIndex =
        DocumentSchemaDto.orderMap[other.id] ?? double.maxFinite.toInt();
    return thisIndex.compareTo(otherIndex);
  }
}

@JsonSerializable()
class DocumentSchemaSectionDto extends Equatable
    implements Comparable<DocumentSchemaSectionDto> {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  @JsonKey(
    toJson: _toJsonProperties,
    fromJson: _fromJsonProperties,
    name: 'properties',
  )
  final List<DocumentSchemaElementDto> elements;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;
  @JsonKey(name: 'if')
  final Map<String, dynamic> ifs;
  final Map<String, dynamic> then; // Return to this
  @JsonKey(name: 'open_source')
  final Map<String, dynamic> openSource; // Return to this

  static late Map<String, int> orderMap;

  const DocumentSchemaSectionDto({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.elements,
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
    required bool isRequired,
  }) {
    orderMap = {for (var i = 0; i < order.length; i++) order[i]: i};
    final sortedElements = List<DocumentSchemaElementDto>.from(this.elements)
      ..sort();
    final elements = sortedElements
        .where((element) => BaseDocumentDefinition.isKnownType(element.ref))
        .map((e) => e.toModel(definitions))
        .toList();
    return DocumentSchemaSection(
      ref: definitions.getDefinition(ref),
      id: id,
      title: title,
      description: description,
      elements: elements,
      isRequired: isRequired,
    );
  }

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        elements,
        required,
        order,
        ifs,
        then,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<DocumentSchemaElementDto> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<DocumentSchemaElementDto> _fromJsonProperties(
    Map<String, dynamic> json,
  ) {
    final listOfProperties = json.convertMapToListWithIds();
    return listOfProperties.map(DocumentSchemaElementDto.fromJson).toList();
  }

  @override
  int compareTo(DocumentSchemaSectionDto other) {
    final thisIndex =
        DocumentSchemaSegmentDto.orderMap[id] ?? double.maxFinite.toInt();
    final otherIndex =
        DocumentSchemaSegmentDto.orderMap[other.id] ?? double.maxFinite.toInt();
    return thisIndex.compareTo(otherIndex);
  }
}

@JsonSerializable()
class DocumentSchemaElementDto extends Equatable
    implements Comparable<DocumentSchemaElementDto> {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  @JsonKey(includeIfNull: false)
  final int? minLength;
  @JsonKey(includeIfNull: false)
  final int? maxLength;
  @JsonKey(name: 'default')
  final String defaultValue;
  @JsonKey(name: 'x-guidance')
  final String guidance;
  @JsonKey(name: 'enum')
  final List<String> enumValues;
  @JsonKey(includeIfNull: false)
  final int? maxItems;
  @JsonKey(includeIfNull: false)
  final int? minItems;
  @JsonKey(includeIfNull: false)
  final int? minimum;
  @JsonKey(includeIfNull: false)
  final int? maximum;
  // TODO(ryszard-schossler): return to this
  final Map<String, dynamic> items;

  const DocumentSchemaElementDto({
    this.ref = '',
    required this.id,
    this.title = '',
    this.description = '',
    required this.minLength,
    required this.maxLength,
    this.defaultValue = '',
    this.guidance = '',
    this.enumValues = const <String>[],
    required this.maxItems,
    required this.minItems,
    required this.minimum,
    required this.maximum,
    this.items = const <String, dynamic>{},
  });

  factory DocumentSchemaElementDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaElementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaElementDtoToJson(this);

  DocumentSchemaElement toModel(List<BaseDocumentDefinition> definitions) {
    return DocumentSchemaElement(
      ref: definitions.getDefinition(ref),
      id: id,
      title: title,
      description: description,
      minLength: minLength,
      maxLength: maxLength,
      defaultValue: defaultValue,
      guidance: guidance,
      enumValues: enumValues,
      range: Range.createIntRange(min: minimum, max: maximum),
      itemsRange: Range.createIntRange(min: minItems, max: maxItems),
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

  @override
  int compareTo(DocumentSchemaElementDto other) {
    final thisIndex =
        DocumentSchemaSectionDto.orderMap[id] ?? double.maxFinite.toInt();
    final otherIndex =
        DocumentSchemaSectionDto.orderMap[other.id] ?? double.maxFinite.toInt();
    return thisIndex.compareTo(otherIndex);
  }
}
