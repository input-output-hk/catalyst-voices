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
    DocumentSchemaProperty<bool> schema,
    bool? value,
  ) {
    // TODO(dtscalac): validate yes no choice
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
