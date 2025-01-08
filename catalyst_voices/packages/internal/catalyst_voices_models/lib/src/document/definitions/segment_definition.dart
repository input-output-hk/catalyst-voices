part of '../document_definitions.dart';

final class SegmentDefinition extends BaseDocumentDefinition {
  final bool additionalProperties;

  const SegmentDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });

  @override
  Object? castValue(Object? value) {
    throw UnsupportedError('Segment cannot have a value');
  }

  @override
  DocumentProperty<Object> castProperty(DocumentProperty<Object> property) {
    throw UnsupportedError('Segment cannot have a property');
  }

  @override
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<Object> schema,
    Object? value,
  ) {
    throw UnsupportedError('Segment cannot have a property');
  }

  @override
  List<Object?> get props => [
        type,
        note,
        additionalProperties,
      ];
}
