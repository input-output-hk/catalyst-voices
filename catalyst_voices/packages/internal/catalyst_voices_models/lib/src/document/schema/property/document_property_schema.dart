import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'document_boolean_schema.dart';
part 'document_integer_schema.dart';
part 'document_list_schema.dart';
part 'document_number_schema.dart';
part 'document_object_schema.dart';
part 'document_string_schema.dart';

sealed class DocumentPropertySchema extends Equatable implements DocumentNode {
  @override
  final DocumentNodeId nodeId;
  final DocumentPropertyType type;
  final DocumentPropertyFormat? format;
  final String title;
  final String? description;
  final bool isRequired;

  const DocumentPropertySchema({
    required this.nodeId,
    required this.type,
    required this.format,
    required this.title,
    required this.description,
    required this.isRequired,
  });

  /// The most nested object ID in the schema.
  String get id => nodeId.lastPath;

  /// new property for the list
  DocumentProperty createProperty([DocumentNodeId? parentNodeId]);

  /// Moves the schema and it's children to a new nodeId
  DocumentPropertySchema withNodeId(DocumentNodeId nodeId);

  @override
  @mustCallSuper
  List<Object?> get props => [
        nodeId,
        type,
        format,
        title,
        description,
        isRequired,
      ];
}

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
    required super.isRequired,
    required this.defaultValue,
    required this.enumValues,
  });

  @override
  DocumentValueProperty<T> createProperty([DocumentNodeId? parentNodeId]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final value = defaultValue;

    return DocumentValueProperty(
      schema: withNodeId(parentNodeId.child(childId)) as DocumentValueSchema<T>,
      value: value,
      validationResult: validatePropertyValue(value),
    );
  }

  DocumentValueProperty<T> castProperty(
    DocumentValueProperty<Object> property,
  ) {
    assert(
      property.schema == this,
      'A property can only be cast by the schema it belongs to',
    );

    return property as DocumentValueProperty<T>;
  }

  T? castValue(Object? value) {
    return value as T?;
  }

  /// Validates the property [value] against document rules.
  DocumentValidationResult validatePropertyValue(T? value);

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [defaultValue, enumValues];
}
