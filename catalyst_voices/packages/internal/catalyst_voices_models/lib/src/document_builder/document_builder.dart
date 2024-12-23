import 'package:catalyst_voices_models/src/document_builder/document_schema.dart';
import 'package:equatable/equatable.dart';

class DocumentBuilder extends Equatable {
  final String schema;
  final List<DocumentBuilderSegment> segments;

  const DocumentBuilder({
    required this.schema,
    required this.segments,
  });

  factory DocumentBuilder.build(DocumentSchema schema) {
    return DocumentBuilder(
      schema: schema.propertiesSchema,
      segments: schema.segments
          .map(
            (element) => DocumentBuilderSegment(
              id: element.id,
              sections: element.sections
                  .map(
                    (element) => DocumentBuilderSection(
                      id: element.id,
                      elements: element.elements
                          .map(
                            (e) => DocumentBuilderElement(
                              id: e.id,
                              value: e.ref.type.defaultValue,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [schema, segments];
}

class DocumentBuilderSegment extends Equatable {
  final String id;
  final List<DocumentBuilderSection> sections;

  const DocumentBuilderSegment({
    required this.id,
    required this.sections,
  });

  @override
  List<Object?> get props => [id, sections];
}

class DocumentBuilderSection extends Equatable {
  final String id;
  final List<DocumentBuilderElement> elements;

  const DocumentBuilderSection({
    required this.id,
    required this.elements,
  });

  @override
  List<Object?> get props => [id, elements];
}

class DocumentBuilderElement extends Equatable {
  final String id;
  final dynamic value;

  const DocumentBuilderElement({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];
}
