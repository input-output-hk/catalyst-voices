part of '../document_definitions.dart';

final class SingleLineTextEntryListDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValues;
  final Map<String, dynamic> items;

  const SingleLineTextEntryListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValues,
    required this.items,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<List<String>> schema,
    List<String>? value,
  ) {
    return DocumentValidator.validateList(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValues,
        items,
      ];
}
