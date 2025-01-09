import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_answers_dto.dart';
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
    DocumentAnswersDto answers,
    DocumentSchema schema,
  ) {
    return DocumentDto(
      schemaUrl: answers.schemaUrl,
      schema: schema,
      segments: schema.segments
          .map(
            (segment) => DocumentSegmentDto.fromJsonSchema(
              segment,
              answers: answers,
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

  DocumentAnswersDto toJson() {
    return DocumentAnswersDto.fromDocument(
      schemaUrl: schemaUrl,
      segments: segments.map((e) => e.toJson()),
    );
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
    required DocumentAnswersDto answers,
  }) {
    return DocumentSegmentDto(
      schema: schema,
      sections: schema.sections
          .map(
            (section) => DocumentSectionDto.fromJsonSchema(
              section,
              answers: answers,
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
    required DocumentAnswersDto answers,
  }) {
    return DocumentSectionDto(
      schema: schema,
      properties: schema.properties
          .map(
            (property) => DocumentPropertyDto.fromJsonSchema(
              property,
              answers: answers,
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
    required DocumentAnswersDto answers,
  }) {
    final property = answers.getProperty(schema.nodeId);
    final value = schema.definition.converter.fromJson(property);
    return DocumentPropertyDto<T>(
      schema: schema,
      value: value,
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
