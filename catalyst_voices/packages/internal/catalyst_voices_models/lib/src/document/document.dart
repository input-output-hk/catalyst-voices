import 'package:catalyst_voices_models/src/document/builder/document_builder.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/schema/document_schema.dart';
import 'package:catalyst_voices_models/src/document/schema/property/document_property_schema.dart';
import 'package:catalyst_voices_models/src/document/validation/document_validation_result.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A class that represents the content described by a [DocumentSchema].
///
/// The document is immutable, in order to edit it make use
/// of [toBuilder] method and act on [DocumentBuilder] instance.
final class Document extends Equatable {
  /// The schema which explains how to interpret this document.
  final DocumentSchema schema;

  /// The top-level groupings for sections.
  final List<DocumentProperty> properties;

  /// The default constructor for the [Document].
  const Document({
    required this.schema,
    required this.properties,
  });

  /// Returns true if all properties in this document are valid,
  /// false otherwise.
  bool get isValid => properties.every((e) => e.isValid);

  @override
  List<Object?> get props => [schema, properties];

  /// Returns the list of segments from filtered [properties].
  List<DocumentObjectProperty> get segments => properties
      .whereType<DocumentObjectProperty>()
      .where((e) => e.schema is DocumentSegmentSchema)
      .toList();

  /// Queries the whole document for the property with [nodeId].
  DocumentProperty? getProperty(DocumentNodeId nodeId) {
    for (final property in properties) {
      final foundProperty = property.getProperty(nodeId);
      if (foundProperty != null) {
        return foundProperty;
      }
    }
    return null;
  }

  /// Creates a new [DocumentBuilder] from this document.
  DocumentBuilder toBuilder() {
    return DocumentBuilder.fromDocument(this);
  }
}

/// A list of properties, each property in [properties]
/// will have exactly the same type.
///
/// More properties of the same type might be added to the list.
final class DocumentListProperty extends DocumentProperty {
  /// The schema of the document property.
  @override
  final DocumentListSchema schema;

  /// The children properties.
  final List<DocumentProperty> properties;

  /// The validation result against the [schema].
  final DocumentValidationResult validationResult;

  const DocumentListProperty({
    required this.schema,
    required this.properties,
    required this.validationResult,
  });

  @override
  bool get isValid {
    if (validationResult.isInvalid) {
      return false;
    }

    return properties.every((e) => e.isValid);
  }

  @override
  bool get isValidExcludingSubsections {
    if (validationResult.isInvalid) {
      return false;
    }

    for (final property in properties) {
      if (property.schema.isSectionOrSubsection) continue;
      if (!property.isValidExcludingSubsections) return false;
    }

    return true;
  }

  @override
  List<Object?> get props => [schema, properties];

  @override
  Object? get value {
    if (properties.isEmpty) return null;

    return properties.map((e) => e.value).toList();
  }

  @override
  DocumentProperty? getProperty(DocumentNodeId nodeId) {
    if (nodeId == this.nodeId) {
      return this;
    }

    if (!nodeId.isChildOf(this.nodeId)) {
      return null;
    }

    for (final property in properties) {
      final foundProperty = property.getProperty(nodeId);
      if (foundProperty != null) {
        return foundProperty;
      }
    }

    return null;
  }

  @override
  DocumentListPropertyBuilder toBuilder() {
    return DocumentListPropertyBuilder.fromProperty(this);
  }
}

/// A list of properties, each property can be a different type.
///
/// More properties cannot be added to the list.
final class DocumentObjectProperty extends DocumentProperty {
  /// The schema of the document property.
  @override
  final DocumentObjectSchema schema;

  /// The children properties.
  final List<DocumentProperty> properties;

  /// The validation result against the [schema].
  final DocumentValidationResult validationResult;

  const DocumentObjectProperty({
    required this.schema,
    required this.properties,
    required this.validationResult,
  });

  @override
  bool get isValid {
    if (validationResult.isInvalid) {
      return false;
    }

    for (final property in properties) {
      if (!property.isValid) return false;
    }

    return true;
  }

  @override
  bool get isValidExcludingSubsections {
    if (validationResult.isInvalid) {
      return false;
    }

    for (final property in properties) {
      if (property.schema.isSectionOrSubsection) continue;
      if (!property.isValidExcludingSubsections) return false;
    }

    return true;
  }

  @override
  List<Object?> get props => [schema, properties, validationResult];

  /// Returns the list of sections from filtered [properties].
  List<DocumentObjectProperty> get sections => properties
      .whereType<DocumentObjectProperty>()
      .where((e) => e.schema is DocumentSectionSchema)
      .toList();

  @override
  Object? get value {
    if (properties.isEmpty) return null;

    return properties.map((e) => e.value).toList();
  }

  @override
  DocumentProperty? getProperty(DocumentNodeId nodeId) {
    if (nodeId == this.nodeId) {
      return this;
    }

    if (!nodeId.isChildOf(this.nodeId)) {
      return null;
    }

    for (final property in properties) {
      final foundProperty = property.getProperty(nodeId);
      if (foundProperty != null) {
        return foundProperty;
      }
    }

    return null;
  }

  DocumentProperty?
      getPropertyWithSchemaType<T extends DocumentPropertySchema>() {
    return properties.firstWhereOrNull((e) => e.schema is T);
  }

  @override
  DocumentObjectPropertyBuilder toBuilder() {
    return DocumentObjectPropertyBuilder.fromProperty(this);
  }
}

/// A property of the [Document].
///
/// See:
/// - [DocumentListProperty]
/// - [DocumentObjectProperty]
/// - [DocumentValueProperty].
sealed class DocumentProperty extends Equatable implements DocumentNode {
  /// The default constructor for the [DocumentProperty].
  const DocumentProperty();

  /// Returns true if the property (including children properties) are valid,
  /// false otherwise.
  bool get isValid;

  /// Return true if the property (including children properties but excluding
  /// children which are standalone sections) are valid, false otherwise.
  bool get isValidExcludingSubsections;

  @override
  DocumentNodeId get nodeId => schema.nodeId;

  /// The schema of the property.
  DocumentPropertySchema get schema;

  /// Returns the value related to this property.
  ///
  /// [DocumentListProperty] - returns a list of values.
  /// [DocumentObjectProperty] - returns a list of values.
  /// [DocumentValueProperty] - returns a singular value.
  Object? get value;

  /// Queries this property and it's children for a property with [nodeId].
  DocumentProperty? getProperty(DocumentNodeId nodeId);

  /// Returns a builder that can update the property state.
  DocumentPropertyBuilder toBuilder();
}

/// A property with a value with no additional children.
final class DocumentValueProperty<T extends Object> extends DocumentProperty {
  /// The schema of the document property.
  @override
  final DocumentValueSchema<T> schema;

  /// The current value this property holds.
  @override
  final T? value;

  /// The validation result against the [schema].
  final DocumentValidationResult validationResult;

  /// The default constructor for the [DocumentValueProperty].
  const DocumentValueProperty({
    required this.schema,
    required this.value,
    required this.validationResult,
  });

  @override
  bool get isValid {
    return validationResult.isValid;
  }

  @override
  bool get isValidExcludingSubsections {
    return validationResult.isValid;
  }

  @override
  List<Object?> get props => [schema, value, validationResult];

  @override
  DocumentProperty? getProperty(DocumentNodeId nodeId) {
    return nodeId == this.nodeId ? this : null;
  }

  /// Creates a new [DocumentValuePropertyBuilder] from this property.
  @override
  DocumentValuePropertyBuilder toBuilder() {
    return DocumentValuePropertyBuilder.fromProperty(this);
  }
}
