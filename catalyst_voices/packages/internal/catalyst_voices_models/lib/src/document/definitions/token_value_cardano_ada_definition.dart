part of '../document_definitions.dart';

final class TokenValueCardanoADADefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const TokenValueCardanoADADefinition({
    required super.type,
    required super.note,
    required this.format,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<int> property) {
    return DocumentValidator.validateNum(property);
  }

  @override
  List<Object?> get props => [
        format,
        type,
        note,
      ];
}
