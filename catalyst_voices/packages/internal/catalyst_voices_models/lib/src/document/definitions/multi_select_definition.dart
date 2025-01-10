part of '../document_definitions.dart';

final class MultiSelectDefinition extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;

  const MultiSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<List<dynamic>> schema,
    List<dynamic>? value,
  ) {
    return DocumentValidator.validateList(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
      ];
}
