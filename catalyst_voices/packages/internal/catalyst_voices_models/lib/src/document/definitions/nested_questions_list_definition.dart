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
  DocumentValidationResult validateProperty(
    DocumentProperty<List<Map<String, dynamic>>> property,
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
