part of '../document_definitions.dart';

final class MultiLineTextEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
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
        contentMediaType,
        pattern,
        type,
        note,
      ];
}
