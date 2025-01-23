part of 'document_property_schema.dart';

sealed class DocumentNumberSchema extends DocumentValueSchema<double> {
  final Range<double>? numRange;

  const DocumentNumberSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required this.numRange,
  }) : super(
          type: DocumentPropertyType.number,
        );

  @override
  DocumentValidationResult validate(double? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateNumberRange(this, value),
    ]);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [numRange];
}

final class DocumentGenericNumberSchema extends DocumentNumberSchema {
  const DocumentGenericNumberSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.numRange,
  });

  const DocumentGenericNumberSchema.optional({
    required super.nodeId,
    super.format,
    super.title = '',
    super.description,
    super.isRequired = false,
    super.defaultValue,
    super.enumValues,
    super.numRange,
  });

  @override
  DocumentGenericNumberSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericNumberSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}
