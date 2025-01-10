part of '../document_definitions.dart';

final class YesNoChoiceDefinition extends BaseDocumentDefinition<bool> {
  final DocumentDefinitionsFormat format;
  final bool defaultValue;

  const YesNoChoiceDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentPropertySchema<bool> schema,
    bool? value,
  ) {
    return DocumentValidator.validateBool(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        type,
        note,
      ];
}
