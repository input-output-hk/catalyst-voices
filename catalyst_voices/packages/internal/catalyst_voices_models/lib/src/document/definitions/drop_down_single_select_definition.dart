part of '../document_definitions.dart';

final class DropDownSingleSelectDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const DropDownSingleSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.contentMediaType,
    required this.pattern,
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
        format,
        contentMediaType,
        pattern,
        type,
        note,
      ];
}
