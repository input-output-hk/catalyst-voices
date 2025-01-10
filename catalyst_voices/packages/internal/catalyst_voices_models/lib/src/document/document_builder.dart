import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_change.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

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

  /// The list of sections that group the [DocumentPropertyValueBuilder].
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
        _sections.indexWhere((e) => change.targetsDocumentNode(e));

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
      properties: schema.properties
          .map(DocumentPropertyValueBuilder.fromSchema)
          .toList(),
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
    final property =
        _properties.firstWhereOrNull((e) => change.targetsDocumentNode(e));

    if (property == null) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this section',
      );
    }

    property.addChange(change);
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

sealed class DocumentPropertyBuilder implements DocumentNode {
  /// The default constructor for the [DocumentPropertyBuilder].
  const DocumentPropertyBuilder();

  /// Creates a [DocumentSectionBuilder] from a [property].
  factory DocumentPropertyBuilder.fromProperty(DocumentProperty property) {
    switch (property) {
      case DocumentPropertyList():
        return DocumentPropertyListBuilder.fromProperty(property);
      case DocumentPropertyObject():
        return DocumentPropertyObjectBuilder.fromProperty(property);
      case DocumentPropertyValue():
        return DocumentPropertyValueBuilder.fromProperty(property);
    }
  }

  /// Applies a change on this builder or any child builder.
  void addChange(DocumentChange change);

  /// Builds an immutable [DocumentProperty].
  DocumentProperty build();
}

final class DocumentPropertyListBuilder extends DocumentPropertyBuilder {
  /// The schema of the document property.
  DocumentSchemaProperty _schema;

  /// The list of children.
  List<DocumentPropertyBuilder> _properties;

  /// The default constructor for the [DocumentPropertyListBuilder].
  DocumentPropertyListBuilder({
    required DocumentSchemaProperty schema,
    required List<DocumentPropertyBuilder> properties,
  })  : _schema = schema,
        _properties = properties;

  /// Creates a [DocumentPropertyListBuilder] from a [schema].
  factory DocumentPropertyListBuilder.fromSchema(
    DocumentSchemaProperty schema,
  ) {
    return DocumentPropertyListBuilder(
      schema: schema,
      // TODO(dtscalac): extract items from schema,
      // assign them default values
      properties: [],
    );
  }

  /// Creates a [DocumentPropertyListBuilder] from existing [property].
  factory DocumentPropertyListBuilder.fromProperty(
    DocumentPropertyList property,
  ) {
    return DocumentPropertyListBuilder(
      schema: property.schema,
      properties: property.properties
          .map(DocumentPropertyBuilder.fromProperty)
          .toList(),
    );
  }

  @override
  DocumentNodeId get nodeId => _schema.nodeId;

  @override
  void addChange(DocumentChange change) {
    switch (change) {
      case DocumentValueChange():
        _handleValueChange(change);
      case DocumentAddListItemChange():
        _handleAddListItemChange(change);
      case DocumentRemoveListItemChange():
        _handleRemoveListItemChange(change);
    }
  }

  /// Builds an immutable [DocumentPropertyList].
  @override
  DocumentPropertyList build() {
    _properties.sortByOrder(_schema.order);

    return DocumentPropertyList(
      schema: _schema,
      properties: _properties.map((e) => e.build()).toList(),
    );
  }

  void _handleValueChange(DocumentValueChange change) {
    for (final property in _properties) {
      if (change.targetsDocumentNode(property)) {
        property.addChange(change);
        return;
      }
    }
  }

  void _handleAddListItemChange(DocumentAddListItemChange change) {
    if (change.nodeId == nodeId) {
      // targets this property

      // TODO(dtscalac): based on schema just create a new property
      // assign new node ID based on the index or something unique.
      //
      // maybe index is not a good idea because if user reorders
      // we want to keep the node id but change the index.
      _properties.add(_properties.last);
    } else {
      // targets child property
      for (final property in _properties) {
        if (change.targetsDocumentNode(property)) {
          property.addChange(change);
          return;
        }
      }

      throw ArgumentError(
        "Couldn't find a suitable node to apply "
        'a change to ${change.nodeId} in this node: $nodeId',
      );
    }
  }

  void _handleRemoveListItemChange(DocumentRemoveListItemChange change) {
    if (change.nodeId == nodeId) {
      // targets this property
      _properties.removeWhere((e) => e.nodeId == change.nodeId);
    } else {
      // targets child property
      for (final property in _properties) {
        if (change.targetsDocumentNode(property)) {
          property.addChange(change);
          return;
        }
      }

      throw ArgumentError(
        "Couldn't find a suitable node to apply "
        'a change to ${change.nodeId} in this node: $nodeId',
      );
    }
  }
}

final class DocumentPropertyObjectBuilder extends DocumentPropertyBuilder {
  /// The schema of the document property.
  DocumentSchemaProperty _schema;

  /// The list of children.
  List<DocumentPropertyBuilder> _properties;

  /// The default constructor for the [DocumentPropertyObjectBuilder].
  DocumentPropertyObjectBuilder({
    required DocumentSchemaProperty schema,
    required List<DocumentPropertyBuilder> properties,
  })  : _schema = schema,
        _properties = properties;

  /// Creates a [DocumentPropertyObjectBuilder] from a [schema].
  factory DocumentPropertyObjectBuilder.fromSchema(
    DocumentSchemaProperty schema,
  ) {
    return DocumentPropertyObjectBuilder(
      schema: schema,
      // TODO(dtscalac): extract items from schema
      properties: [],
    );
  }

  /// Creates a [DocumentPropertyObjectBuilder] from existing [property].
  factory DocumentPropertyObjectBuilder.fromProperty(
    DocumentPropertyObject property,
  ) {
    return DocumentPropertyObjectBuilder(
      schema: property.schema,
      properties: property.properties
          .map(DocumentPropertyBuilder.fromProperty)
          .toList(),
    );
  }

  @override
  DocumentNodeId get nodeId => _schema.nodeId;

  @override
  void addChange(DocumentChange change) {
    for (final property in _properties) {
      if (change.targetsDocumentNode(property)) {
        property.addChange(change);
        return;
      }
    }
  }

  /// Builds an immutable [DocumentPropertyObject].
  @override
  DocumentPropertyObject build() {
    _properties.sortByOrder(_schema.order);

    return DocumentPropertyObject(
      schema: _schema,
      properties: _properties.map((e) => e.build()).toList(),
    );
  }
}

final class DocumentPropertyValueBuilder<T extends Object>
    extends DocumentPropertyBuilder {
  /// The schema of the document property.
  DocumentSchemaProperty<T> _schema;

  /// The current value this property holds.
  T? _value;

  /// The default constructor for the [DocumentPropertyValueBuilder].
  DocumentPropertyValueBuilder({
    required DocumentSchemaProperty<T> schema,
    required T? value,
  })  : _schema = schema,
        _value = value;

  /// Creates a [DocumentPropertyValueBuilder] from a [schema].
  factory DocumentPropertyValueBuilder.fromSchema(
    DocumentSchemaProperty<T> schema,
  ) {
    return DocumentPropertyValueBuilder(
      schema: schema,
      value: schema.defaultValue,
    );
  }

  /// Creates a [DocumentPropertyValueBuilder] from existing [property].
  factory DocumentPropertyValueBuilder.fromProperty(
    DocumentPropertyValue<T> property,
  ) {
    return DocumentPropertyValueBuilder(
      schema: property.schema,
      value: property.value,
    );
  }

  @override
  DocumentNodeId get nodeId => _schema.nodeId;

  @override
  void addChange(DocumentChange change) {
    if (change is! DocumentValueChange) {
      throw ArgumentError(
        '$DocumentPropertyValueBuilder only supports $DocumentValueChange',
      );
    }

    if (_schema.nodeId != change.nodeId) {
      throw ArgumentError(
        'Cannot apply change to ${_schema.nodeId}, '
        'the target node is ${change.nodeId}',
      );
    }

    _value = _schema.definition.castValue(change.value);
  }

  /// Builds an immutable [DocumentPropertyValue].
  @override
  DocumentPropertyValue<T> build() {
    return DocumentPropertyValue(
      schema: _schema,
      value: _value,
      validationResult: _schema.validatePropertyValue(_value),
    );
  }
}
