part of 'document_property_schema.dart';

final class DocumentGenericNumberSchema extends DocumentNumberSchema {
  const DocumentGenericNumberSchema({
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
    required super.multipleOf,
  });

  const DocumentGenericNumberSchema.optional({
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
    super.multipleOf,
  });

  @override
  DocumentGenericNumberSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentGenericNumberSchema(
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
      multipleOf: multipleOf,
    );
  }
}

sealed class DocumentNumberSchema extends DocumentValueSchema<double> {
  final Range<double?>? numRange;
  final double? multipleOf;

  const DocumentNumberSchema({
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
    required this.multipleOf,
  }) : super(
         type: DocumentPropertyType.number,
       );

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [numRange, multipleOf];

  @override
  DocumentNumberSchema copyWith({DocumentNodeId? nodeId, String? title});

  @override
  DocumentValidationResult validate(double? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateNumberRange(this, value),
      DocumentValidator.validateNumberMultipleOf(this, value),
      DocumentValidator.validateConstValue(this, value),
      DocumentValidator.validateEnumValues(this, value),
    ]);
  }
}
