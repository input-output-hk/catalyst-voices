part of '../document_definitions.dart';

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
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<String> schema,
    String? value,
  ) {
    final stringValidationResult =
        DocumentValidator.validateString(schema, value);
    if (stringValidationResult.isInvalid) {
      return stringValidationResult;
    }
    return DocumentValidator.validatePattern(schema, pattern, value);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}
