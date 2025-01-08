part of '../document_definitions.dart';

final class AgreementConfirmationDefinition
    extends BaseDocumentDefinition<bool> {
  final DocumentDefinitionsFormat format;
  final bool defaultValue;
  final bool constValue;

  const AgreementConfirmationDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
    required this.constValue,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<bool> schema,
    bool? value,
  ) {
    return DocumentValidator.validateBool(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        constValue,
        type,
        note,
      ];
}
