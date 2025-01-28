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
    required super.isSubsection,
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
      DocumentValidator.validateEnumValues(this, value),
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentTokenValueCardanoAdaSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentTokenValueCardanoAdaSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentDurationInMonthsSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentDurationInMonthsSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
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
    required super.isSubsection,
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
    super.isSubsection = false,
    super.isRequired = false,
    super.defaultValue,
    super.constValue,
    super.enumValues,
    super.numRange,
  });

  @override
  DocumentGenericIntegerSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentGenericIntegerSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}
