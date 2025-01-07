part of 'document_definitions.dart';

final class DurationInMonthsDefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const DurationInMonthsDefinition({
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
        type,
        note,
        format,
      ];
}
