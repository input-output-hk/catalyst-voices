import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'document_boolean_schema.dart';
part 'document_integer_schema.dart';
part 'document_list_schema.dart';
part 'document_number_schema.dart';
part 'document_object_schema.dart';
part 'document_string_schema.dart';

/// A schema of [DocumentProperty].
/// Defines the type, formatting, appearance and validation rules.
///
/// There are two major types of properties, grouping properties:
/// - [DocumentObjectSchema]
/// - [DocumentListSchema]
///
/// and properties with values:
///
/// - [DocumentValueSchema]
/// - [DocumentBooleanSchema]
/// - [DocumentIntegerSchema]
/// - [DocumentNumberSchema]
/// - [DocumentStringSchema]
///
/// Grouping properties have children, value properties have values.
sealed class DocumentPropertySchema extends Equatable implements DocumentNode {
  @override
  final DocumentNodeId nodeId;
  final DocumentPropertyType type;
  final DocumentPropertyFormat? format;
  final String title;
  final MarkdownData? description;
  final String? placeholder;
  final String? guidance;

  /// True if the property must exist and be non-nullable,
  /// false if the property may not exist or be nullable.
  final bool isRequired;

  const DocumentPropertySchema({
    required this.nodeId,
    required this.type,
    required this.format,
    required this.title,
    required this.description,
    required this.placeholder,
    required this.guidance,
    required this.isRequired,
  });

  /// The most nested object ID in the schema.
  String get id => nodeId.lastPath;

  /// Creates a new property from this schema with a default value.
  ///
  /// Specify the [parentNodeId] if the created property should
  /// be moved to another node. By default it is created under
  /// the same node that this schema points to.
  ///
  /// This is useful to create new items for the [DocumentListProperty].
  DocumentProperty createChildPropertyAt([DocumentNodeId? parentNodeId]);

  /// Moves the schema and it's children to the [nodeId].
  DocumentPropertySchema withNodeId(DocumentNodeId nodeId);

  @override
  @mustCallSuper
  List<Object?> get props => [
        nodeId,
        type,
        format,
        title,
        description,
        placeholder,
        guidance,
        isRequired,
      ];
}

/// A schema property that can have a value.
sealed class DocumentValueSchema<T extends Object>
    extends DocumentPropertySchema {
  final T? defaultValue;
  final List<T>? enumValues;

  const DocumentValueSchema({
    required super.nodeId,
    required super.type,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required this.defaultValue,
    required this.enumValues,
  });

  /// A method that builds typed properties.
  ///
  /// Helps to create properties which generic type [T]
  /// is synced with the schema's generic type.
  DocumentValueProperty<T> buildProperty({required T? value}) {
    return DocumentValueProperty<T>(
      schema: this,
      value: value,
      validationResult: validate(value),
    );
  }

  @override
  DocumentValueProperty<T> createChildPropertyAt([
    DocumentNodeId? parentNodeId,
  ]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final value = defaultValue;

    final updatedSchema =
        withNodeId(parentNodeId.child(childId)) as DocumentValueSchema<T>;

    return updatedSchema.buildProperty(value: value);
  }

  /// Casts the property linked to this schema so that
  /// the property generic value type is synced with schema type.
  DocumentValueProperty<T> castProperty(
    DocumentValueProperty<Object> property,
  ) {
    assert(
      property.schema == this,
      'A property can only be cast by the schema it belongs to',
    );

    return property as DocumentValueProperty<T>;
  }

  /// Casts the property value linked to this schema so that
  /// the property value type is synced with schema type.
  T? castValue(Object? value) {
    return value as T?;
  }

  /// Validates the property [value] against document rules.
  DocumentValidationResult validate(T? value);

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [defaultValue, enumValues];
}
