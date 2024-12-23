import 'package:catalyst_voices_models/src/document_builder/document_schema.dart';
import 'package:equatable/equatable.dart';

final class DocumentBuilder extends Equatable {
  final String schema;
  final List<DocumentBuilderSegment> segments;

  const DocumentBuilder({
    required this.schema,
    required this.segments,
  });

  factory DocumentBuilder.build(DocumentSchema schema) {
    return DocumentBuilder(
      schema: schema.propertiesSchema,
      segments: schema.segments.map(DocumentBuilderSegment.build).toList(),
    );
  }

  @override
  List<Object?> get props => [schema, segments];
}

final class DocumentBuilderSegment extends Equatable {
  final String id;
  final List<DocumentBuilderSection> sections;

  const DocumentBuilderSegment({
    required this.id,
    required this.sections,
  });

  factory DocumentBuilderSegment.build(DocumentSchemaSegment segment) {
    return DocumentBuilderSegment(
      id: segment.id,
      sections: segment.sections.map(DocumentBuilderSection.build).toList(),
    );
  }

  @override
  List<Object?> get props => [id, sections];
}

final class DocumentBuilderSection extends Equatable {
  final String id;
  final List<DocumentBuilderElement> elements;

  const DocumentBuilderSection({
    required this.id,
    required this.elements,
  });

  factory DocumentBuilderSection.build(DocumentSchemaSection section) {
    return DocumentBuilderSection(
      id: section.id,
      elements: section.elements.map(DocumentBuilderElement.build).toList(),
    );
  }

  @override
  List<Object?> get props => [id, elements];
}

final class DocumentBuilderElement extends Equatable {
  final String id;
  final dynamic value;

  const DocumentBuilderElement({
    required this.id,
    required this.value,
  });

  factory DocumentBuilderElement.build(DocumentSchemaElement element) {
    return DocumentBuilderElement(
      id: element.id,
      // TODO(dtscalac): provide value
      value: element.ref.type.defaultValue,
    );
  }

  @override
  List<Object?> get props => [id, value];
}
