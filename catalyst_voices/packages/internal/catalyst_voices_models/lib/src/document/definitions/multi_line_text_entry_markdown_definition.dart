part of '../document_definitions.dart';

final class MultiLineTextEntryMarkdownDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryMarkdownDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];
}
