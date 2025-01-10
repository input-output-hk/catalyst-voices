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
    DocumentPropertySchema<String> schema,
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
