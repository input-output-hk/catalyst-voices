import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_change.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// A mutable document builder that understands the [DocumentSchema].
///
/// All edits are done on this instance of the builder,
/// copying is not supported for performance reasons.
///
/// Once edits are done convert the builder to a [Document] with [build] method.
final class DocumentBuilder implements DocumentNode {
  String _schemaUrl;
  DocumentSchema _schema;
  List<DocumentSegmentBuilder> _segments;

  /// The default constructor for the [DocumentBuilder].
  DocumentBuilder({
    required String schemaUrl,
    required DocumentSchema schema,
    required List<DocumentSegmentBuilder> segments,
  })  : _schemaUrl = schemaUrl,
        _schema = schema,
        _segments = segments;

  /// Creates an empty [DocumentBuilder] from a [schema].
  factory DocumentBuilder.fromSchema({
    required String schemaUrl,
    required DocumentSchema schema,
  }) {
    return DocumentBuilder(
      schemaUrl: schemaUrl,
      schema: schema,
      segments: schema.segments.map(DocumentSegmentBuilder.fromSchema).toList(),
    );
  }

  /// Creates a [DocumentBuilder] from existing [document].
  factory DocumentBuilder.fromDocument(Document document) {
    return DocumentBuilder(
      schemaUrl: document.schemaUrl,
      schema: document.schema,
      segments:
          document.segments.map(DocumentSegmentBuilder.fromSegment).toList(),
    );
  }

  @override
  DocumentNodeId get nodeId => DocumentNodeId.root;

  /// Applies [changes] in FIFO manner on this builder.
  void addChanges(List<DocumentChange> changes) {
    for (final change in changes) {
      addChange(change);
    }
  }

  /// Applies a [change] on this instance of the builder
  /// without creating a copy.
  void addChange(DocumentChange change) {
    final segmentIndex =
        _segments.indexWhere((e) => change.nodeId.isChildOf(e._schema.nodeId));

    if (segmentIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this document',
      );
    }

    _segments[segmentIndex].addChange(change);
  }

  /// Builds an immutable [Document].
  Document build() {
    _segments.sortByOrder(_schema.order);

    return Document(
      schemaUrl: _schemaUrl,
      schema: _schema,
      segments: List.unmodifiable(_segments.map((e) => e.build())),
    );
  }
}

final class DocumentSegmentBuilder implements DocumentNode {
  /// The schema of the document segment.
  DocumentSchemaSegment _schema;

  /// The list of sections that group the [DocumentPropertyBuilder].
  List<DocumentSectionBuilder> _sections;

  /// The default constructor for the [DocumentSegmentBuilder].
  DocumentSegmentBuilder({
    required DocumentSchemaSegment schema,
    required List<DocumentSectionBuilder> sections,
  })  : _schema = schema,
        _sections = sections;

  /// Creates a [DocumentSegmentBuilder] from a [schema].
  factory DocumentSegmentBuilder.fromSchema(DocumentSchemaSegment schema) {
    return DocumentSegmentBuilder(
      schema: schema,
      sections: schema.sections.map(DocumentSectionBuilder.fromSchema).toList(),
    );
  }

  /// Creates a [DocumentSegmentBuilder] from existing [segment].
  factory DocumentSegmentBuilder.fromSegment(DocumentSegment segment) {
    return DocumentSegmentBuilder(
      schema: segment.schema,
      sections:
          segment.sections.map(DocumentSectionBuilder.fromSection).toList(),
    );
  }

  @override
  DocumentNodeId get nodeId => _schema.nodeId;

  /// Applies a [change] on this instance.
  void addChange(DocumentChange change) {
    final sectionIndex =
        _sections.indexWhere((e) => change.nodeId.isChildOf(e._schema.nodeId));

    if (sectionIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this segment',
      );
    }

    _sections[sectionIndex].addChange(change);
  }

  /// Builds an immutable [DocumentSegment].
  DocumentSegment build() {
    _sections.sortByOrder(_schema.order);

    return DocumentSegment(
      schema: _schema,
      sections: List.unmodifiable(_sections.map((e) => e.build())),
    );
  }
}

final class DocumentSectionBuilder implements DocumentNode {
  /// The schema of the document section.
  DocumentSchemaSection _schema;

  /// The list of properties within this section.
  List<DocumentPropertyBuilder> _properties;

  /// The default constructor for the [DocumentSectionBuilder].
  DocumentSectionBuilder({
    required DocumentSchemaSection schema,
    required List<DocumentPropertyBuilder> properties,
  })  : _schema = schema,
        _properties = properties;

  /// Creates a [DocumentSectionBuilder] from a [schema].
  factory DocumentSectionBuilder.fromSchema(DocumentSchemaSection schema) {
    return DocumentSectionBuilder(
      schema: schema,
      properties:
          schema.properties.map(DocumentPropertyBuilder.fromSchema).toList(),
    );
  }

  /// Creates a [DocumentSectionBuilder] from existing [section].
  factory DocumentSectionBuilder.fromSection(DocumentSection section) {
    return DocumentSectionBuilder(
      schema: section.schema,
      properties:
          section.properties.map(DocumentPropertyBuilder.fromProperty).toList(),
    );
  }

  @override
  DocumentNodeId get nodeId => _schema.nodeId;

  /// Applies a [change] on this instance.
  void addChange(DocumentChange change) {
    final propertyIndex =
        _properties.indexWhere((e) => e._schema.nodeId == change.nodeId);

    if (propertyIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this section',
      );
    }

    _properties[propertyIndex].addChange(change);
  }

  /// Builds an immutable [DocumentSection].
  DocumentSection build() {
    _properties.sortByOrder(_schema.order);

    return DocumentSection(
      schema: _schema,
      properties: List.unmodifiable(_properties.map((e) => e.build())),
    );
  }
}

final class DocumentPropertyBuilder<T extends Object> implements DocumentNode {
  /// The schema of the document property.
  DocumentSchemaProperty<T> _schema;

  /// The current value this property holds.
  T? _value;

  /// The default constructor for the [DocumentPropertyBuilder].
  DocumentPropertyBuilder({
    required DocumentSchemaProperty<T> schema,
    required T? value,
  })  : _schema = schema,
        _value = value;

  /// Creates a [DocumentPropertyBuilder] from a [schema].
  factory DocumentPropertyBuilder.fromSchema(DocumentSchemaProperty<T> schema) {
    return DocumentPropertyBuilder(
      schema: schema,
      value: schema.defaultValue,
    );
  }

  /// Creates a [DocumentPropertyBuilder] from existing [property].
  factory DocumentPropertyBuilder.fromProperty(DocumentProperty<T> property) {
    return DocumentPropertyBuilder(
      schema: property.schema,
      value: property.value,
    );
  }

  @override
  DocumentNodeId get nodeId => _schema.nodeId;

  /// Applies a [change] on this property.
  void addChange(DocumentChange change) {
    if (_schema.nodeId != change.nodeId) {
      throw ArgumentError(
        'Cannot apply change to ${_schema.nodeId}, '
        'the target node is ${change.nodeId}',
      );
    }

    _value = _schema.definition.castValue(change.value);
  }

  /// Builds an immutable [DocumentProperty].
  DocumentProperty<T> build() {
    return DocumentProperty(
      schema: _schema,
      value: _value,
      validationResult: _schema.validatePropertyValue(_value),
    );
  }
}
