import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_properties_dto.dart';

/// A data transfer object for the [Document].
///
/// Encodable as json but to decode with [DocumentDto.fromJsonSchema]
/// a [DocumentSchema] is needed which explains how to interpret the data.
final class DocumentDto {
  final DocumentSchema schema;
  final List<DocumentSegmentDto> segments;

  const DocumentDto({
    required this.schema,
    required this.segments,
  });

  factory DocumentDto.fromJsonSchema(
    Map<String, dynamic> json,
    DocumentSchema schema,
  ) {
    final properties = DocumentPropertiesDto.fromJson(json);

    return DocumentDto(
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
      schema: model.schema,
      segments: model.segments.map(DocumentSegmentDto.fromModel).toList(),
    );
  }

  Document toModel() {
    // building a document via builder to sort segments/sections/properties
    return DocumentBuilder(
      schema: schema,
      segments: segments
          .map((e) => DocumentSegmentBuilder.fromSegment(e.toModel()))
          .toList(),
    ).build();
  }

  Map<String, dynamic> toJson() {
    return {
      r'$schema': schema,
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

final class DocumentPropertyDto {
  final DocumentSchemaProperty schema;
  final dynamic value;

  const DocumentPropertyDto({
    required this.schema,
    required this.value,
  });

  factory DocumentPropertyDto.fromJsonSchema(
    DocumentSchemaProperty schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentPropertyDto(
      schema: schema,
      // TODO(dtscalac): validate that value is of correct type, ignore if not
      value: properties.getProperty(schema.nodeId),
    );
  }

  factory DocumentPropertyDto.fromModel(DocumentProperty model) {
    return DocumentPropertyDto(
      schema: model.schema,
      // TODO(dtscalac): convert to json from model
      value: model.value,
    );
  }

  DocumentProperty toModel() {
    return DocumentProperty(
      schema: schema,
      // TODO(dtscalac): convert from json to model
      value: value,
    );
  }

  Map<String, dynamic> toJson() => {
        schema.id: value,
      };
}
