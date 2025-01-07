part of 'document_definitions.dart';

final class TagGroupDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const TagGroupDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @visibleForTesting
  const TagGroupDefinition.dummy()
      : this(
          type: DocumentDefinitionsObjectType.string,
          note: '',
          format: DocumentDefinitionsFormat.tagGroup,
          pattern: '',
        );

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}
