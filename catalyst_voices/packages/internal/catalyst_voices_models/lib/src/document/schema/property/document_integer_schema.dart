part of 'document_property_schema.dart';

sealed class DocumentIntegerSchema extends DocumentValueSchema<int> {
  final Range<int>? numRange;

  const DocumentIntegerSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required this.numRange,
  }) : super(
          type: DocumentPropertyType.integer,
        );

  @override
  DocumentValidationResult validate(int? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateIntegerRange(this, value),
      DocumentValidator.validateConstValue(this, value),
    ]);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [numRange];
}

final class DocumentTokenValueCardanoAdaSchema extends DocumentIntegerSchema {
  const DocumentTokenValueCardanoAdaSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentTokenValueCardanoAdaSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentTokenValueCardanoAdaSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}

final class DocumentDurationInMonthsSchema extends DocumentIntegerSchema {
  const DocumentDurationInMonthsSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentDurationInMonthsSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentDurationInMonthsSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}

final class DocumentGenericIntegerSchema extends DocumentIntegerSchema {
  const DocumentGenericIntegerSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
  });

  const DocumentGenericIntegerSchema.optional({
    required super.nodeId,
    super.format,
    super.title = '',
    super.description,
    super.placeholder,
    super.guidance,
    super.isRequired = false,
    super.defaultValue,
    super.constValue,
    super.enumValues,
    super.numRange,
  });

  @override
  DocumentGenericIntegerSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericIntegerSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}
