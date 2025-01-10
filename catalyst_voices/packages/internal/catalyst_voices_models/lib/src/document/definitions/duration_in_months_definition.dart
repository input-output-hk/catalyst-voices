part of '../document_definitions.dart';

final class DurationInMonthsDefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const DurationInMonthsDefinition({
    required super.type,
    required super.note,
    required this.format,
  });

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentPropertySchema<int> schema,
    int? value,
  ) {
    return DocumentValidator.validateNum(schema, value);
  }

  @override
  List<Object?> get props => [
        type,
        note,
        format,
      ];
}
