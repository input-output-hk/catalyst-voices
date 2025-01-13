import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_properties_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_converter_ext.dart';

/// A data transfer object for the [Document].
///
/// Encodable as json but to decode with [DocumentDto.fromJsonSchema]
/// a [DocumentSchema] is needed which explains how to interpret the data.
final class DocumentDto {
  final String schemaUrl;
  final DocumentSchema schema;
  final List<DocumentSegmentDto> segments;

  const DocumentDto({
    required this.schemaUrl,
    required this.schema,
    required this.segments,
  });

  factory DocumentDto.fromJsonSchema(
    Map<String, dynamic> json,
    DocumentSchema schema,
  ) {
    final properties = DocumentPropertiesDto.fromJson(json);

    return DocumentDto(
      schemaUrl: json[r'$schema'] as String,
      schema: schema,
      segments: schema.segments
          .map(
            (segment) => DocumentSegmentDto.fromJsonSchema(
              segment,
              properties: properties,
            ),
          )
          .toList(),
    );
  }

  factory DocumentDto.fromModel(Document model) {
    return DocumentDto(
      schemaUrl: model.schemaUrl,
      schema: model.schema,
      segments: model.segments.map(DocumentSegmentDto.fromModel).toList(),
    );
  }

  Document toModel() {
    // building a document via builder to sort segments/sections/properties
    return DocumentBuilder(
      schemaUrl: schemaUrl,
      schema: schema,
      segments: segments
          .map((e) => DocumentSegmentBuilder.fromSegment(e.toModel()))
          .toList(),
    ).build();
  }

  Map<String, dynamic> toJson() {
    return {
      r'$schema': schemaUrl,
      for (final segment in segments) ...segment.toJson(),
    };
  }
}

final class DocumentSegmentDto {
  final DocumentSegmentSchema schema;
  final List<DocumentSectionDto> sections;

  const DocumentSegmentDto({
    required this.schema,
    required this.sections,
  });

  factory DocumentSegmentDto.fromJsonSchema(
    DocumentSegmentSchema schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentSegmentDto(
      schema: schema,
      sections: schema.sections
          .map(
            (section) => DocumentSectionDto.fromJsonSchema(
              section,
              properties: properties,
            ),
          )
          .toList(),
    );
  }

  factory DocumentSegmentDto.fromModel(DocumentSegment model) {
    return DocumentSegmentDto(
      schema: model.schema,
      sections: model.sections.map(DocumentSectionDto.fromModel).toList(),
    );
  }

  DocumentSegment toModel() {
    return DocumentSegment(
      schema: schema,
      sections: sections.map((e) => e.toModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      schema.id: {
        for (final section in sections) ...section.toJson(),
      },
    };
  }
}

final class DocumentSectionDto {
  final DocumentSectionSchema schema;
  final List<DocumentPropertyDto> properties;

  const DocumentSectionDto({
    required this.schema,
    required this.properties,
  });

  factory DocumentSectionDto.fromJsonSchema(
    DocumentSectionSchema schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentSectionDto(
      schema: schema,
      properties: schema.properties
          .map(
            (property) => DocumentPropertyValueDto.fromJsonSchema(
              property,
              properties: properties,
            ),
          )
          .toList(),
    );
  }

  factory DocumentSectionDto.fromModel(DocumentSection model) {
    return DocumentSectionDto(
      schema: model.schema,
      properties: model.properties.map(DocumentPropertyDto.fromModel).toList(),
    );
  }

  DocumentSection toModel() {
    return DocumentSection(
      schema: schema,
      properties: properties.map((e) => e.toModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      schema.id: {
        for (final property in properties) ...property.toJson(),
      },
    };
  }
}

sealed class DocumentPropertyDto {
  const DocumentPropertyDto();

  factory DocumentPropertyDto.fromJsonSchema(
    DocumentPropertySchema schema, {
    required DocumentPropertiesDto properties,
  }) {
    switch (schema.definition.type) {
      case DocumentDefinitionsObjectType.array:
        return DocumentPropertyListDto.fromJsonSchema(
          schema,
          properties: properties,
        );
      case DocumentDefinitionsObjectType.object:
        return DocumentPropertyObjectDto.fromJsonSchema(
          schema,
          properties: properties,
        );
      case DocumentDefinitionsObjectType.string:
      case DocumentDefinitionsObjectType.integer:
      case DocumentDefinitionsObjectType.number:
      case DocumentDefinitionsObjectType.boolean:
        return DocumentPropertyValueDto.fromJsonSchema(
          schema,
          properties: properties,
        );
    }
  }

  factory DocumentPropertyDto.fromModel(DocumentProperty property) {
    switch (property) {
      case DocumentPropertyList():
        return DocumentPropertyListDto.fromModel(property);
      case DocumentPropertyObject():
        return DocumentPropertyObjectDto.fromModel(property);
      case DocumentPropertyValue():
        return DocumentPropertyValueDto.fromModel(property);
    }
  }

  DocumentProperty toModel();

  Map<String, dynamic> toJson();
}

final class DocumentPropertyListDto extends DocumentPropertyDto {
  final DocumentPropertySchema schema;
  final List<DocumentPropertyDto> properties;

  const DocumentPropertyListDto({
    required this.schema,
    required this.properties,
  });

  factory DocumentPropertyListDto.fromJsonSchema(
    DocumentPropertySchema schema, {
    required DocumentPropertiesDto properties,
  }) {
    final values = properties.getProperty(schema.nodeId) as List? ?? [];
    final itemSchema = schema.items!;
    return DocumentPropertyListDto(
      schema: schema,
      properties: [
        // TODO(dtscalac): random nodeId
        for (final value in values)
          DocumentPropertyValueDto(
            schema: itemSchema,
            value: itemSchema.definition.converter.fromJson(value),
          ),
      ],
    );
  }

  factory DocumentPropertyListDto.fromModel(DocumentPropertyList model) {
    return DocumentPropertyListDto(
      schema: model.schema,
      properties: model.properties.map(DocumentPropertyDto.fromModel).toList(),
    );
  }

  @override
  DocumentPropertyList toModel() {
    return DocumentPropertyList(
      schema: schema,
      properties: properties.map((e) => e.toModel()).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: [
          for (final property in properties) property.toJson(),
        ],
      };
}

final class DocumentPropertyObjectDto extends DocumentPropertyDto {
  final DocumentPropertySchema schema;
  final List<DocumentPropertyDto> properties;

  const DocumentPropertyObjectDto({
    required this.schema,
    required this.properties,
  });

  factory DocumentPropertyObjectDto.fromJsonSchema(
    DocumentPropertySchema schema, {
    required DocumentPropertiesDto properties,
  }) {
    final schemaProperties = schema.properties ?? const [];
    return DocumentPropertyObjectDto(
      schema: schema,
      properties: schemaProperties.map((childSchema) {
        return DocumentPropertyDto.fromJsonSchema(
          childSchema,
          properties: properties,
        );
      }).toList(),
    );
  }

  factory DocumentPropertyObjectDto.fromModel(DocumentPropertyObject model) {
    return DocumentPropertyObjectDto(
      schema: model.schema,
      properties: model.properties.map(DocumentPropertyDto.fromModel).toList(),
    );
  }

  @override
  DocumentPropertyObject toModel() {
    return DocumentPropertyObject(
      schema: schema,
      properties: properties.map((e) => e.toModel()).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: {
          for (final property in properties) ...property.toJson(),
        },
      };
}

final class DocumentPropertyValueDto<T extends Object>
    extends DocumentPropertyDto {
  final DocumentPropertySchema<T> schema;
  final T? value;

  const DocumentPropertyValueDto({
    required this.schema,
    required this.value,
  });

  factory DocumentPropertyValueDto.fromJsonSchema(
    DocumentPropertySchema<T> schema, {
    required DocumentPropertiesDto properties,
  }) {
    final property = properties.getProperty(schema.nodeId);
    final value = schema.definition.converter.fromJson(property);
    return DocumentPropertyValueDto<T>(
      schema: schema,
      value: value,
    );
  }

  factory DocumentPropertyValueDto.fromModel(DocumentPropertyValue<T> model) {
    return DocumentPropertyValueDto<T>(
      schema: model.schema,
      value: model.value,
    );
  }

  @override
  DocumentPropertyValue<T> toModel() {
    return DocumentPropertyValue<T>(
      schema: schema,
      value: value,
      validationResult: schema.validatePropertyValue(value),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        schema.id: schema.definition.converter.toJson(value),
      };
}
