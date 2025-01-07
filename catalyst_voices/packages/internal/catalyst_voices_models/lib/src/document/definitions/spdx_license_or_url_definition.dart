part of '../document_definitions.dart';

final class SPDXLicenceOrUrlDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;
  final DocumentDefinitionsContentMediaType contentMediaType;

  const SPDXLicenceOrUrlDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
    required this.contentMediaType,
  });

  @override
  DocumentValidationResult validateProperty(DocumentProperty<String> property) {
    return DocumentValidator.validateString(property);
  }

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];
}
