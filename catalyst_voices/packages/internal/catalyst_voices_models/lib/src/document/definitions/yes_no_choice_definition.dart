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
  DocumentValidationResult validateProperty(DocumentProperty<bool> property) {
    return DocumentValidator.validateBool(property);
  }

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        type,
        note,
      ];
}
