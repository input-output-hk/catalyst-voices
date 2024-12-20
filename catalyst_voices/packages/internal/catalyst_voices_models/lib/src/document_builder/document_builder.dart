import 'package:catalyst_voices_models/src/document_builder/document_schema.dart';

class DocumentBuilder {
  final String schema;
  final List<DocumentBuilderSegment> segments;

  const DocumentBuilder({
    required this.schema,
    required this.segments,
  });

  factory DocumentBuilder.build(DocumentSchema proposalSchema) {
    return DocumentBuilder(
      schema: proposalSchema.propertiesSchema,
      segments: proposalSchema.segments
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
                              value: e.ref.type.getDefaultValue,
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
}

class DocumentBuilderSegment {
  final String id;
  final List<DocumentBuilderSection> sections;

  const DocumentBuilderSegment({
    required this.id,
    required this.sections,
  });
}

class DocumentBuilderSection {
  final String id;
  final List<DocumentBuilderElement> elements;

  const DocumentBuilderSection({
    required this.id,
    required this.elements,
  });
}

class DocumentBuilderElement {
  final String id;
  final dynamic value;

  const DocumentBuilderElement({
    required this.id,
    required this.value,
  });
}
