part of '../document_definitions.dart';

// TODO(dtscalac): parse the Map<String, dynamic> into a question properties
final class NestedQuestionsListDefinition
    extends BaseDocumentDefinition<List<Map<String, dynamic>>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValue;

  const NestedQuestionsListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<List<Map<String, dynamic>>> schema,
    List<Map<String, dynamic>>? value,
  ) {
    return DocumentValidator.validateList(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
      ];
}
