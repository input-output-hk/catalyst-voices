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
  /// The url of the [schema].
  final String schemaUrl;

  /// The schema which explains how to interpret this document.
  final DocumentSchema schema;

  /// The top-level groupings for sections.
  final List<DocumentProperty> properties;

  /// The default constructor for the [Document].
  const Document({
    required this.schemaUrl,
    required this.schema,
    required this.properties,
  });

  /// Returns the list of segments from filtered [properties].
  List<DocumentObjectProperty> get segments => properties
      .whereType<DocumentObjectProperty>()
      .where((e) => e.schema is DocumentSegmentSchema)
      .toList();

  /// Creates a new [DocumentBuilder] from this document.
  DocumentBuilder toBuilder() {
    return DocumentBuilder.fromDocument(this);
  }

  @override
  List<Object?> get props => [schemaUrl, schema, properties];
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

  @override
  DocumentNodeId get nodeId => schema.nodeId;

  /// The schema of the property.
  DocumentPropertySchema get schema;

  /// Returns true if the property (including children properties) are valid,
  /// false otherwise.
  bool get isValid;

  /// Returns a builder that can update the property state.
  DocumentPropertyBuilder toBuilder();
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

    for (final property in properties) {
      if (!property.isValid) return false;
    }

    return true;
  }

  @override
  DocumentListPropertyBuilder toBuilder() {
    return DocumentListPropertyBuilder.fromProperty(this);
  }

  @override
  List<Object?> get props => [schema, properties];
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

  DocumentProperty?
      getPropertyWithSchemaType<T extends DocumentPropertySchema>() {
    return properties.firstWhereOrNull((e) => e.schema is T);
  }

  /// Returns the list of sections from filtered [properties].
  List<DocumentObjectProperty> get sections => properties
      .whereType<DocumentObjectProperty>()
      .where((e) => e.schema is DocumentSectionSchema)
      .toList();

  @override
  DocumentObjectPropertyBuilder toBuilder() {
    return DocumentObjectPropertyBuilder.fromProperty(this);
  }

  @override
  List<Object?> get props => [schema, properties, validationResult];
}

/// A property with a value with no additional children.
final class DocumentValueProperty<T extends Object> extends DocumentProperty {
  /// The schema of the document property.
  @override
  final DocumentValueSchema<T> schema;

  /// The current value this property holds.
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

  /// Creates a new [DocumentValuePropertyBuilder] from this property.
  @override
  DocumentValuePropertyBuilder toBuilder() {
    return DocumentValuePropertyBuilder.fromProperty(this);
  }

  @override
  List<Object?> get props => [schema, value, validationResult];
}
