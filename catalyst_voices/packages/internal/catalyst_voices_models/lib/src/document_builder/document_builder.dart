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

  const DocumentBuilder({
    required this.schema,
    required this.segments,
  });

  // TODO(dtscalac): accept current user responses
  factory DocumentBuilder.from(DocumentSchema schema) {
    return DocumentBuilder(
      schema: schema.propertiesSchema,
      segments: schema.segments.map(DocumentBuilderSegment.from).toList(),
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

  final List<DocumentBuilderSection> sections;

  const DocumentBuilderSegment({
    required this.id,
    required this.nodeId,
    required this.sections,
  });

  factory DocumentBuilderSegment.from(DocumentSchemaSegment segment) {
    final nodeId = DocumentNodeId.root.child(segment.id);

    return DocumentBuilderSegment(
      id: segment.id,
      nodeId: nodeId,
      sections: segment.sections
          .map(
            (segment) => DocumentBuilderSection.from(
              segment,
              parentNodeId: nodeId,
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

  const DocumentBuilderSection({
    required this.id,
    required this.nodeId,
    required this.elements,
  });

  factory DocumentBuilderSection.from(
    DocumentSchemaSection section, {
    required DocumentNodeId parentNodeId,
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

  const DocumentBuilderElement({
    required this.id,
    required this.nodeId,
    required this.value,
  });

  factory DocumentBuilderElement.from(
    DocumentSchemaElement element, {
    required DocumentNodeId parentNodeId,
  }) {
    return DocumentBuilderElement(
      id: element.id,
      nodeId: parentNodeId.child(element.id),
      // TODO(dtscalac): provide value
      value: null,
    );
  }

  @override
  List<Object?> get props => [id, nodeId, value];
}

/// The unique id of an object in a document for segments/sections/elements
/// in a format of paths from the top-level node down to the nested node.
extension type const DocumentNodeId._(List<String> _paths) {
  /// The top-level node in the document.
  static const DocumentNodeId root = DocumentNodeId._([]);

  /// Returns a parent node.
  ///
  /// For [root] node it returns [root] node as it doesn't have any parent.
  DocumentNodeId parent() {
    if (_paths.isEmpty) {
      return this;
    }

    final paths = List.of(_paths)..removeLast();
    return DocumentNodeId._(paths);
  }

  /// Returns a child node at given [path].
  ///
  /// The [path] is appended to the parent's [path].
  DocumentNodeId child(String path) {
    return DocumentNodeId._([
      ..._paths,
      path,
    ]);
  }
}
