import 'package:catalyst_voices_models/src/document/document_builder.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:catalyst_voices_models/src/document/document_validator.dart';
import 'package:equatable/equatable.dart';

// TODO(dtscalac): tests

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
  final List<DocumentSegment> segments;

  /// The default constructor for the [Document].
  const Document({
    required this.schemaUrl,
    required this.schema,
    required this.segments,
  });

  /// Creates a new [DocumentBuilder] from this document.
  DocumentBuilder toBuilder() {
    return DocumentBuilder.fromDocument(this);
  }

  @override
  List<Object?> get props => [schemaUrl, schema, segments];
}

/// A segment that groups multiple [DocumentSection]'s.
final class DocumentSegment extends Equatable {
  /// The schema of the document segment.
  final DocumentSchemaSegment schema;

  /// The list of sections that group the [DocumentPropertyValue].
  final List<DocumentSection> sections;

  /// The default constructor for the [DocumentSegment].
  const DocumentSegment({
    required this.schema,
    required this.sections,
  });

  /// Creates a new [DocumentSegmentBuilder] from this segment.
  DocumentSegmentBuilder toBuilder() {
    return DocumentSegmentBuilder.fromSegment(this);
  }

  @override
  List<Object?> get props => [schema, sections];
}

/// A section that groups multiple [DocumentPropertyValue]'s.
final class DocumentSection extends Equatable {
  /// The schema of the document section.
  final DocumentSchemaSection schema;

  /// The list of properties within this section.
  final List<DocumentProperty> properties;

  /// The default constructor for the [DocumentSection].
  const DocumentSection({
    required this.schema,
    required this.properties,
  });

  /// Returns `false` if any of the section [properties] is invalid,
  /// `true` otherwise.
  bool get isValid {
    for (final property in properties) {
      if (!property.isValid) return false;
    }
    return true;
  }

  /// Creates a new [DocumentSectionBuilder] from this section.
  DocumentSectionBuilder toBuilder() {
    return DocumentSectionBuilder.fromSection(this);
  }

  @override
  List<Object?> get props => [schema, properties];
}

/// A child of [DocumentSection].
///
/// Describes a property of the document which is
/// neither a [DocumentSegment] nor a [DocumentSection].
sealed class DocumentProperty extends Equatable {
  const DocumentProperty();

  DocumentSchemaProperty get schema;

  bool get isValid;
}

/// A list of properties, each property in [properties]
/// will have exactly the same type.
///
/// More properties of the same type might be added to the list.
final class DocumentPropertyList extends DocumentProperty {
  @override
  final DocumentSchemaProperty schema;
  final List<DocumentProperty> properties;

  const DocumentPropertyList({
    required this.schema,
    required this.properties,
  });

  @override
  bool get isValid {
    for (final property in properties) {
      if (!property.isValid) return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [schema, properties];
}

/// A list of properties, each property can be a different type.
///
/// More properties cannot be added to the list.
final class DocumentPropertyObject extends DocumentProperty {
  @override
  final DocumentSchemaProperty schema;
  final List<DocumentProperty> properties;

  const DocumentPropertyObject({
    required this.schema,
    required this.properties,
  });

  @override
  bool get isValid {
    for (final property in properties) {
      if (!property.isValid) return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [schema, properties];
}

/// A property with a value with no additional children.
final class DocumentPropertyValue<T extends Object> extends DocumentProperty {
  /// The schema of the document property.
  @override
  final DocumentSchemaProperty<T> schema;

  /// The current value this property holds.
  final T? value;

  /// The validation result for the [value] against the [schema].
  final DocumentValidationResult validationResult;

  /// The default constructor for the [DocumentPropertyValue].
  const DocumentPropertyValue({
    required this.schema,
    required this.value,
    required this.validationResult,
  });

  @override
  bool get isValid {
    return validationResult.isValid;
  }

  /// Creates a new [DocumentPropertyValueBuilder] from this property.
  DocumentPropertyValueBuilder toBuilder() {
    return DocumentPropertyValueBuilder.fromProperty(this);
  }

  @override
  List<Object?> get props => [schema, value, validationResult];
}
