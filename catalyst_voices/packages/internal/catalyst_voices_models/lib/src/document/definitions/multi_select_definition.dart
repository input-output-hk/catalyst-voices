part of 'document_definitions.dart';

final class MultiSelectDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;

  const MultiSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<dynamic>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
      ];
}
