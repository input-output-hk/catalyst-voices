import 'package:catalyst_voices_models/src/document/builder/document_change.dart';
import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/schema/document_schema.dart';
import 'package:catalyst_voices_models/src/document/schema/property/document_property_schema.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

/// A mutable document builder that understands the [DocumentSchema].
///
/// All edits are done on this instance of the builder,
/// copying is not supported for performance reasons.
///
/// Once edits are done convert the builder to a [Document] with [build] method.
final class DocumentBuilder {
  String _schemaUrl;
  DocumentSchema _schema;
  List<DocumentPropertyBuilder> _properties;

  /// The default constructor for the [DocumentBuilder].
  DocumentBuilder({
    required String schemaUrl,
    required DocumentSchema schema,
    required List<DocumentPropertyBuilder> properties,
  })  : _schemaUrl = schemaUrl,
        _schema = schema,
        _properties = properties;

  /// Creates an empty [DocumentBuilder] from a [schema].
  factory DocumentBuilder.fromSchema({
    required String schemaUrl,
    required DocumentSchema schema,
  }) {
    return DocumentBuilder(
      schemaUrl: schemaUrl,
      schema: schema,
      properties:
          schema.properties.map(DocumentPropertyBuilder.fromSchema).toList(),
    );
  }

  /// Creates a [DocumentBuilder] from existing [document].
  factory DocumentBuilder.fromDocument(Document document) {
    return DocumentBuilder(
      schemaUrl: document.schemaUrl,
      schema: document.schema,
      properties: document.properties
          .map(DocumentPropertyBuilder.fromProperty)
          .toList(),
    );
  }

  /// Applies [changes] in FIFO manner on this builder.
  void addChanges(List<DocumentChange> changes) {
    for (final change in changes) {
      addChange(change);
    }
  }

  /// Applies a [change] on this instance of the builder
  /// without creating a copy.
  void addChange(DocumentChange change) {
    final propertyIndex =
        _properties.indexWhere((e) => change.targetsDocumentNode(e));

    if (propertyIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this document',
      );
    }

    _properties[propertyIndex].addChange(change);
  }

  /// Builds an immutable [Document].
  Document build() {
    final mappedProperties = _properties.map((e) => e.build()).toList()
      ..sortByOrder(_schema.order);

    return Document(
      schemaUrl: _schemaUrl,
      schema: _schema,
      properties: List.unmodifiable(mappedProperties),
    );
  }
}

/// A builder for a single [DocumentProperty].
sealed class DocumentPropertyBuilder implements DocumentNode {
  /// The default constructor for the [DocumentPropertyBuilder].
  const DocumentPropertyBuilder();

  /// Creates a [DocumentPropertyBuilder] from a [schema].
  factory DocumentPropertyBuilder.fromSchema(
    DocumentPropertySchema schema,
  ) {
    switch (schema) {
      case DocumentListSchema():
        return DocumentListPropertyBuilder.fromSchema(schema);
      case DocumentObjectSchema():
        return DocumentObjectPropertyBuilder.fromSchema(schema);
      case DocumentValueSchema():
        return DocumentValuePropertyBuilder.fromSchema(schema);
    }
  }

  /// Creates a [DocumentPropertyBuilder] from a [property].
  factory DocumentPropertyBuilder.fromProperty(DocumentProperty property) {
    switch (property) {
      case DocumentListProperty():
        return DocumentListPropertyBuilder.fromProperty(property);
      case DocumentObjectProperty():
        return DocumentObjectPropertyBuilder.fromProperty(property);
      case DocumentValueProperty():
        return DocumentValuePropertyBuilder.fromProperty(property);
    }
  }

  /// Applies a change on this builder or any child builder.
  void addChange(DocumentChange change);

  /// Builds an immutable [DocumentProperty].
  DocumentProperty build();
}

/// A [DocumentProperty] builder suited to work with [DocumentListProperty].
final class DocumentListPropertyBuilder extends DocumentPropertyBuilder {
  /// The schema of the document property.
  DocumentListSchema _schema;

  /// The list of children properties.
  List<DocumentPropertyBuilder> _properties;

  /// The default constructor for the [DocumentListPropertyBuilder].
  DocumentListPropertyBuilder({
    required DocumentListSchema schema,
    required List<DocumentPropertyBuilder> properties,
  })  : _schema = schema,
        _properties = properties;

  /// Creates a [DocumentListPropertyBuilder] from a [schema].
  factory DocumentListPropertyBuilder.fromSchema(
    DocumentListSchema schema,
  ) {
    return DocumentListPropertyBuilder(
      schema: schema,
      properties: [],
    );
  }

  /// Creates a [DocumentListPropertyBuilder] from existing [property].
  factory DocumentListPropertyBuilder.fromProperty(
    DocumentListProperty property,
  ) {
    return DocumentListPropertyBuilder(
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

  /// Builds an immutable [DocumentListProperty].
  @override
  DocumentListProperty build() {
    final mappedProperties = _properties.map((e) => e.build());

    return _schema.buildProperty(
      properties: List.unmodifiable(mappedProperties),
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
      final property = _schema.itemsSchema.createChildPropertyAt();
      _properties.add(DocumentPropertyBuilder.fromProperty(property));
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

      final targetProperty = _properties
          .firstWhereOrNull((property) => change.targetsDocumentNode(property));

      if (targetProperty == null) {
        throw ArgumentError(
          "Couldn't find a suitable node to apply "
          'a change to ${change.nodeId} in this node: $nodeId',
        );
      }

      targetProperty.addChange(change);
    }
  }
}

/// A [DocumentProperty] builder suited to work with [DocumentObjectProperty].
final class DocumentObjectPropertyBuilder extends DocumentPropertyBuilder {
  /// The schema of the document property.
  DocumentObjectSchema _schema;

  /// The list of children properties.
  List<DocumentPropertyBuilder> _properties;

  /// The default constructor for the [DocumentObjectPropertyBuilder].
  DocumentObjectPropertyBuilder({
    required DocumentObjectSchema schema,
    required List<DocumentPropertyBuilder> properties,
  })  : _schema = schema,
        _properties = properties;

  /// Creates a [DocumentObjectPropertyBuilder] from a [schema].
  factory DocumentObjectPropertyBuilder.fromSchema(
    DocumentObjectSchema schema,
  ) {
    final properties = schema.properties;
    return DocumentObjectPropertyBuilder(
      schema: schema,
      properties: properties.map(DocumentPropertyBuilder.fromSchema).toList(),
    );
  }

  /// Creates a [DocumentObjectPropertyBuilder] from existing [property].
  factory DocumentObjectPropertyBuilder.fromProperty(
    DocumentObjectProperty property,
  ) {
    return DocumentObjectPropertyBuilder(
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

  /// Builds an immutable [DocumentObjectProperty].
  @override
  DocumentObjectProperty build() {
    final mappedProperties = _properties.map((e) => e.build()).toList()
      ..sortByOrder(_schema.order);

    return _schema.buildProperty(
      properties: List.unmodifiable(mappedProperties),
    );
  }
}

/// A [DocumentProperty] builder suited to work with [DocumentValueProperty].
final class DocumentValuePropertyBuilder<T extends Object>
    extends DocumentPropertyBuilder {
  /// The schema of the document property.
  DocumentValueSchema<T> _schema;

  /// The current value this property holds.
  T? _value;

  /// The default constructor for the [DocumentValuePropertyBuilder].
  DocumentValuePropertyBuilder({
    required DocumentValueSchema<T> schema,
    required T? value,
  })  : _schema = schema,
        _value = value;

  /// Creates a [DocumentValuePropertyBuilder] from a [schema].
  factory DocumentValuePropertyBuilder.fromSchema(
    DocumentValueSchema<T> schema,
  ) {
    return DocumentValuePropertyBuilder(
      schema: schema,
      value: schema.defaultValue,
    );
  }

  /// Creates a [DocumentValuePropertyBuilder] from existing [property].
  factory DocumentValuePropertyBuilder.fromProperty(
    DocumentValueProperty<T> property,
  ) {
    return DocumentValuePropertyBuilder(
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
        '$DocumentValuePropertyBuilder only supports $DocumentValueChange',
      );
    }

    if (_schema.nodeId != change.nodeId) {
      throw ArgumentError(
        'Cannot apply change to ${_schema.nodeId}, '
        'the target node is ${change.nodeId}',
      );
    }

    _value = _schema.castValue(change.value);
  }

  /// Builds an immutable [DocumentValueProperty].
  @override
  DocumentValueProperty<T> build() {
    return _schema.buildProperty(value: _value);
  }
}
