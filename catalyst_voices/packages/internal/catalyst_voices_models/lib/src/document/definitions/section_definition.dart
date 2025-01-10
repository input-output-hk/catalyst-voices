part of '../document_definitions.dart';

final class SectionDefinition extends BaseDocumentDefinition {
  final bool additionalProperties;

  const SectionDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });

  @override
  Object? castValue(Object? value) {
    throw UnsupportedError('Section cannot have a value');
  }

  @override
  DocumentPropertyValue<Object> castProperty(
    DocumentPropertyValue<Object> property,
  ) {
    throw UnsupportedError('Section cannot have a property');
  }

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<Object> schema,
    Object? value,
  ) {
    throw UnsupportedError('Section cannot have a property');
  }

  @override
  List<Object?> get props => [
        additionalProperties,
        type,
        note,
      ];
}
