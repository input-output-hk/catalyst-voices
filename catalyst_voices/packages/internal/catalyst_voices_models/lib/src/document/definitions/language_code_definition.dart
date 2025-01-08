part of '../document_definitions.dart';

final class LanguageCodeDefinition extends BaseDocumentDefinition<String> {
  final String defaultValue;
  final List<String> enumValues;

  const LanguageCodeDefinition({
    required super.type,
    required super.note,
    required this.defaultValue,
    required this.enumValues,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<String> schema,
    String? value,
  ) {
    return DocumentValidator.validateString(schema, value);
  }

  @override
  List<Object?> get props => [
        defaultValue,
        enumValues,
        note,
        type,
      ];
}
