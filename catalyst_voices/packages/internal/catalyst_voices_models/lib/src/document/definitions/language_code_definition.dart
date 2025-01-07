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
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        defaultValue,
        enumValues,
        note,
        type,
      ];
}
