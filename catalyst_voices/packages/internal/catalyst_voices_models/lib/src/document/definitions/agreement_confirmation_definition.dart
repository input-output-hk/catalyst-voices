part of 'document_definitions.dart';

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
  DocumentValidationResult validateProperty(DocumentProperty<bool> property) {
    return DocumentValidator.validateBool(property);
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
