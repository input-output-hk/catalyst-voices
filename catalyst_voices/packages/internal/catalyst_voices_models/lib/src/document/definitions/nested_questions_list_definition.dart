part of 'document_definitions.dart';

final class NestedQuestionsListDefinition
    extends BaseDocumentDefinition<List<String>> {
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
      ];
}
