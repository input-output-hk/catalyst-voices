part of '../document_definitions.dart';

// TODO(dtscalac): parse into a list with properties
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
  DocumentValidationResult validatePropertyValue(
    DocumentPropertySchema<List<String>> schema,
    List<String>? value,
  ) {
    return DocumentValidator.validateList(schema, value);
  }

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];
}
