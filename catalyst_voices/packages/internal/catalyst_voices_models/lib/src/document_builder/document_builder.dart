import 'package:catalyst_voices_models/src/document_builder/document.dart';
import 'package:catalyst_voices_models/src/document_builder/document_node_id.dart';
import 'package:catalyst_voices_models/src/document_builder/document_schema.dart';
import 'package:equatable/equatable.dart';

/// A class that understands the [DocumentSchema] and is able to collect
/// all required inputs to build a valid document.
///
/// The builder is immutable, all edits must return
/// a new copy of the builder with edited properties.
final class DocumentBuilder extends Equatable {
  final String schema;
  final List<DocumentBuilderSegment> segments;

  /// The default constructor for the [DocumentBuilder].
  const DocumentBuilder({
    required this.schema,
    required this.segments,
  });

  /// Creates a [DocumentBuilder] from a [schema] and optionally
  /// from a [document].
  ///
  /// If the [document] is given the
  /// [DocumentBuilderElement] values will be filled.
  factory DocumentBuilder.from(DocumentSchema schema, {Document? document}) {
    return DocumentBuilder(
      schema: schema.propertiesSchema,
      segments: schema.segments
          .map(
            (segment) =>
                DocumentBuilderSegment.from(segment, document: document),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [schema, segments];
}

final class DocumentBuilderSegment extends Equatable {
  /// The identifier of the segment within a [DocumentBuilderSegment].
  ///
  /// Since segments are top-level their ids cannot be repeated.
  final String id;

  /// The identifier of the object within a whole [DocumentBuilder].
  final DocumentNodeId nodeId;

  /// The list of sections that group the [DocumentBuilderElement].
  final List<DocumentBuilderSection> sections;

  /// The default constructor for the [DocumentBuilderSegment].
  const DocumentBuilderSegment({
    required this.id,
    required this.nodeId,
    required this.sections,
  });

  /// Creates a [DocumentBuilderSegment] from a [segment] and optionally
  /// from a [document].
  ///
  /// If the [document] is given the
  /// [DocumentBuilderElement.value] values will be filled.
  factory DocumentBuilderSegment.from(
    DocumentSchemaSegment segment, {
    Document? document,
  }) {
    final nodeId = DocumentNodeId.root.child(segment.id);

    return DocumentBuilderSegment(
      id: segment.id,
      nodeId: nodeId,
      sections: segment.sections
          .map(
            (segment) => DocumentBuilderSection.from(
              segment,
              parentNodeId: nodeId,
              document: document,
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, nodeId, sections];
}

final class DocumentBuilderSection extends Equatable {
  /// The identifier of the section within a [DocumentBuilderSegment].
  ///
  /// Might be repeated in other segments.
  final String id;

  /// The identifier of the object within a whole [DocumentBuilder].
  final DocumentNodeId nodeId;

  /// The list of elements within this section.
  final List<DocumentBuilderElement> elements;

  /// The default constructor for the [DocumentBuilderSection].
  const DocumentBuilderSection({
    required this.id,
    required this.nodeId,
    required this.elements,
  });

  /// Creates a [DocumentBuilderSection] from a [section] and optionally
  /// from a [document].
  ///
  /// If the [document] is given the
  /// [DocumentBuilderElement.value] will be filled.
  factory DocumentBuilderSection.from(
    DocumentSchemaSection section, {
    required DocumentNodeId parentNodeId,
    Document? document,
  }) {
    final nodeId = parentNodeId.child(section.id);

    return DocumentBuilderSection(
      id: section.id,
      nodeId: nodeId,
      elements: section.elements
          .map(
            (section) => DocumentBuilderElement.from(
              section,
              parentNodeId: nodeId,
              document: document,
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, nodeId, elements];
}

final class DocumentBuilderElement extends Equatable {
  /// The identifier of the element within a [DocumentBuilderSection].
  ///
  /// Might be repeated in other sections.
  final String id;

  /// The identifier of the object within a whole [DocumentBuilder].
  final DocumentNodeId nodeId;

  /// The current value this element holds.
  final Object? value;

  /// The default constructor for the [DocumentBuilderElement].
  const DocumentBuilderElement({
    required this.id,
    required this.nodeId,
    required this.value,
  });

  /// Creates a [DocumentBuilderSection] from an [element] and optionally
  /// from a [document].
  ///
  /// If the [document] is given the [value] will be filled.
  factory DocumentBuilderElement.from(
    DocumentSchemaElement element, {
    required DocumentNodeId parentNodeId,
    Document? document,
  }) {
    final nodeId = parentNodeId.child(element.id);
    // TODO(dtscalac): convert from raw property into
    // enums/lists as needed by value
    // TODO(dtscalac): validate that value is of correct type, ignore if not
    return DocumentBuilderElement(
      id: element.id,
      nodeId: nodeId,
      value: document?.getProperty(nodeId),
    );
  }

  @override
  List<Object?> get props => [id, nodeId, value];
}
