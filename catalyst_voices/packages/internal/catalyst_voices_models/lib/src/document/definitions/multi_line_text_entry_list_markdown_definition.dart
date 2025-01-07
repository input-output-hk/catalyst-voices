part of '../document_definitions.dart';

final class MultiLineTextEntryListMarkdownDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValue;
  final Map<String, dynamic> items;

  const MultiLineTextEntryListMarkdownDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
        items,
      ];
}
