part of 'document_definitions.dart';

final class SingleLineHttpsURLEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const SingleLineHttpsURLEntryDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

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
