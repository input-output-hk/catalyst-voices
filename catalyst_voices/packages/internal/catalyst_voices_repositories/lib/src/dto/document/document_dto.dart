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
  final DocumentSchemaSegment schema;
  final List<DocumentSectionDto> sections;

  const DocumentSegmentDto({
    required this.schema,
    required this.sections,
  });

  factory DocumentSegmentDto.fromJsonSchema(
    DocumentSchemaSegment schema, {
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
  final DocumentSchemaSection schema;
  final List<DocumentPropertyDto> properties;

  const DocumentSectionDto({
    required this.schema,
    required this.properties,
  });

  factory DocumentSectionDto.fromJsonSchema(
    DocumentSchemaSection schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentSectionDto(
      schema: schema,
      properties: schema.properties
          .map(
            (property) => DocumentPropertyDto.fromJsonSchema(
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

final class DocumentPropertyDto<T extends Object> {
  final DocumentSchemaProperty<T> schema;
  final T? value;

  const DocumentPropertyDto({
    required this.schema,
    required this.value,
  });

  factory DocumentPropertyDto.fromJsonSchema(
    DocumentSchemaProperty<T> schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentPropertyDto<T>(
      schema: schema,
      value: schema.definition.converter
          .fromJson(properties.getProperty(schema.nodeId)),
    );
  }

  factory DocumentPropertyDto.fromModel(DocumentProperty<T> model) {
    return DocumentPropertyDto<T>(
      schema: model.schema,
      value: model.value,
    );
  }

  DocumentProperty<T> toModel() {
    return DocumentProperty<T>(
      schema: schema,
      value: value,
      validationResult: schema.validatePropertyValue(value),
    );
  }

  Map<String, dynamic> toJson() => {
        schema.id: schema.definition.converter.toJson(value),
      };
}
