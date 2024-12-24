import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_properties_dto.dart';
import 'package:equatable/equatable.dart';

/// A data transfer object for the [Document].
///
/// Encodable as json but to decode with [DocumentDto.fromJsonSchema]
/// a [DocumentSchema] is needed which explains how to interpret the data.
class DocumentDto extends Equatable {
  final String schema;
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
      schema: schema.schema,
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
    return Document(
      schema: schema,
      segments: segments.map((e) => e.toModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      r'$schema': schema,
      for (final segment in segments) ...segment.toJson(),
    };
  }

  @override
  List<Object?> get props => [schema, segments];
}

class DocumentSegmentDto extends Equatable {
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

  @override
  List<Object?> get props => [schema, sections];
}

class DocumentSectionDto extends Equatable {
  final DocumentSchemaSection schema;
  final List<DocumentElementDto> elements;

  const DocumentSectionDto({
    required this.schema,
    required this.elements,
  });

  factory DocumentSectionDto.fromJsonSchema(
    DocumentSchemaSection schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentSectionDto(
      schema: schema,
      elements: schema.elements
          .map(
            (element) => DocumentElementDto.fromJsonSchema(
              element,
              properties: properties,
            ),
          )
          .toList(),
    );
  }

  factory DocumentSectionDto.fromModel(DocumentSection model) {
    return DocumentSectionDto(
      schema: model.schema,
      elements: model.elements.map(DocumentElementDto.fromModel).toList(),
    );
  }

  DocumentSection toModel() {
    return DocumentSection(
      schema: schema,
      elements: elements.map((e) => e.toModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      schema.id: {
        for (final element in elements) ...element.toJson(),
      },
    };
  }

  @override
  List<Object?> get props => [schema, elements];
}

class DocumentElementDto extends Equatable {
  final DocumentSchemaElement schema;
  final dynamic value;

  const DocumentElementDto({
    required this.schema,
    required this.value,
  });

  factory DocumentElementDto.fromJsonSchema(
    DocumentSchemaElement schema, {
    required DocumentPropertiesDto properties,
  }) {
    return DocumentElementDto(
      schema: schema,
      // TODO(dtscalac): validate that value is of correct type, ignore if not
      value: properties.getProperty(schema.nodeId),
    );
  }

  factory DocumentElementDto.fromModel(DocumentElement model) {
    return DocumentElementDto(
      schema: model.schema,
      // TODO(dtscalac): convert to json from model
      value: model.value,
    );
  }

  DocumentElement toModel() {
    return DocumentElement(
      schema: schema,
      // TODO(dtscalac): convert from json to model
      value: value,
    );
  }

  Map<String, dynamic> toJson() => {
        schema.id: value,
      };

  @override
  List<Object?> get props => [schema, value];
}
