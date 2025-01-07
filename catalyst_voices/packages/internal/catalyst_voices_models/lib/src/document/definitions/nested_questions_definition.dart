part of '../document_definitions.dart';

// TODO(ryszard-schossler): Verify BaseDocumentDefinition type
final class NestedQuestionsDefinition
    extends BaseDocumentDefinition<List<String>> {
  final DocumentDefinitionsFormat format;
  final bool additionalProperties;

  const NestedQuestionsDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<List<String>> property,
  ) {
    return DocumentValidator.validateList(property);
  }

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];
}
