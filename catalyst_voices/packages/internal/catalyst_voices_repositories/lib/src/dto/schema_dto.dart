import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/definitions_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schema_dto.g.dart';

@JsonSerializable()
class SchemaDto extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;
  @JsonKey(name: r'$id')
  final String id;
  final String title;
  final String description;
  final DefinitionsDto definitions;
  final String type;
  final bool additionalProperties;
  @JsonKey(toJson: _toJsonProperties, fromJson: _fromJsonProperties)
  final List<SchemaSegmentDto> properties;
  @JsonKey(name: 'x-order')
  final List<String> order;
  @JsonKey(includeToJson: false)
  final String propertiesSchema;

  const SchemaDto({
    required this.schema,
    required this.id,
    required this.title,
    required this.description,
    required this.definitions,
    this.type = 'object',
    this.additionalProperties = false,
    required this.properties,
    required this.order,
    required this.propertiesSchema,
  });

  factory SchemaDto.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['propertiesSchema'] =
        (segmentsMap[r'$schema'] as Map<String, dynamic>)['const'];

    return _$SchemaDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SchemaDtoToJson(this);

  Schema toModel() {
    final properties =
        this.properties.map((e) => e.toModel(definitions.definitions)).toList();
    return Schema(
      schema: schema,
      title: title,
      description: description,
      type: DefinitionsObjectType.fromString(type),
      additionalProperties: false,
      segments: properties,
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
        properties,
        order,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<SchemaSegmentDto> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<SchemaSegmentDto> _fromJsonProperties(Map<String, dynamic> json) {
    final listOfProperties = json.convertMapToListWithIds();
    return listOfProperties.map(SchemaSegmentDto.fromJson).toList();
  }
}

@JsonSerializable()
class SchemaSegmentDto extends Equatable {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  @JsonKey(toJson: _toJsonProperties, fromJson: _fromJsonProperties)
  final List<SchemaSectionDto> properties;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;

  static late Map<String, int> orderMap;

  const SchemaSegmentDto({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
  });

  factory SchemaSegmentDto.fromJson(Map<String, dynamic> json) =>
      _$SchemaSegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaSegmentDtoToJson(this);

  SchemaSegment toModel(List<BaseDefinition> definitions) {
    orderMap = {for (var i = 0; i < order.length; i++) order[i]: i};
    final sortedProperties = List<SchemaSectionDto>.from(properties)..sort();
    final sections = sortedProperties
        .where((element) => element.ref.contains('section'))
        .map((e) => e.toModel(definitions, isRequired: required.contains(e.id)))
        .toList();
    return SchemaSegment(
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
        properties,
        required,
        order,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<SchemaSectionDto> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<SchemaSectionDto> _fromJsonProperties(Map<String, dynamic> json) {
    final listOfProperties = json.convertMapToListWithIds();
    return listOfProperties.map(SchemaSectionDto.fromJson).toList();
  }
}

@JsonSerializable()
class SchemaSectionDto extends Equatable
    implements Comparable<SchemaSectionDto> {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  @JsonKey(toJson: _toJsonProperties, fromJson: _fromJsonProperties)
  final List<SchemaElementDto> properties;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;
  final Map<String, dynamic> dependencies; // Return to this
  @JsonKey(name: 'if')
  final Map<String, dynamic> ifs;
  final Map<String, dynamic> then; // Return to this
  @JsonKey(name: 'open_source')
  final Map<String, dynamic> openSource; // Return to this

  static late Map<String, int> orderMap;

  const SchemaSectionDto({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
    this.dependencies = const <String, dynamic>{},
    this.ifs = const <String, dynamic>{},
    this.then = const <String, dynamic>{},
    this.openSource = const <String, dynamic>{},
  });

  factory SchemaSectionDto.fromJson(Map<String, dynamic> json) =>
      _$SchemaSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaSectionDtoToJson(this);

  SchemaSection toModel(
    List<BaseDefinition> definitions, {
    required bool isRequired,
  }) {
    orderMap = {for (var i = 0; i < order.length; i++) order[i]: i};
    final sortedProperties = List<SchemaElementDto>.from(properties)..sort();
    final elements = sortedProperties
        // .where((element) => element.ref.contains('section'))
        .map((e) => e.toModel(definitions))
        .toList();
    return SchemaSection(
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
        properties,
        required,
        order,
        dependencies,
        ifs,
        then,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<SchemaElementDto> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }

  static List<SchemaElementDto> _fromJsonProperties(Map<String, dynamic> json) {
    final listOfProperties = json.convertMapToListWithIds();
    return listOfProperties.map(SchemaElementDto.fromJson).toList();
  }

  @override
  int compareTo(SchemaSectionDto other) {
    final thisIndex = SchemaSegmentDto.orderMap[id] ?? double.maxFinite.toInt();
    final otherIndex =
        SchemaSegmentDto.orderMap[other.id] ?? double.maxFinite.toInt();
    return thisIndex.compareTo(otherIndex);
  }
}

@JsonSerializable()
class SchemaElementDto extends Equatable
    implements Comparable<SchemaElementDto> {
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
  final List<String> examples;
  final Map<String, dynamic> items; // TODO(ryszard-shossler): return to this

  const SchemaElementDto({
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
    this.examples = const <String>[],
    this.items = const <String, dynamic>{},
  });

  factory SchemaElementDto.fromJson(Map<String, dynamic> json) =>
      _$SchemaElementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaElementDtoToJson(this);

  SchemaElement toModel(List<BaseDefinition> definitions) => SchemaElement(
        ref: definitions.getDefinition(ref),
        id: id,
        title: title,
        description: description,
        minLength: minLength,
        maxLength: maxLength,
        defaultValue: defaultValue,
        guidance: guidance,
        enumValues: enumValues,
        maxItems: maxItems,
        minItems: minItems,
        minimum: minimum,
        maximum: maximum,
        examples: examples,
      );

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
        examples,
      ];

  @override
  int compareTo(SchemaElementDto other) {
    final thisIndex = SchemaSectionDto.orderMap[id] ?? double.maxFinite.toInt();
    final otherIndex =
        SchemaSectionDto.orderMap[other.id] ?? double.maxFinite.toInt();
    return thisIndex.compareTo(otherIndex);
  }
}
