part of '../document_definitions.dart';

final class TagSelectionDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const TagSelectionDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @visibleForTesting
  const TagSelectionDefinition.dummy()
      : this(
          type: DocumentDefinitionsObjectType.string,
          note: '',
          format: DocumentDefinitionsFormat.tagSelection,
          pattern: '',
        );

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<String> schema,
    String? value,
  ) {
    return DocumentValidator.validateString(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}
