part of 'document_property_schema.dart';

sealed class DocumentBooleanSchema extends DocumentValueSchema<bool> {
  const DocumentBooleanSchema({
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
  }) : super(
          type: DocumentPropertyType.boolean,
        );

  @override
  DocumentValidationResult validate(bool? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateConstValue(this, value),
    ]);
  }
}

final class DocumentYesNoChoiceSchema extends DocumentBooleanSchema {
  const DocumentYesNoChoiceSchema({
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
  });

  @override
  DocumentYesNoChoiceSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentYesNoChoiceSchema(
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
    );
  }
}

final class DocumentAgreementConfirmationSchema extends DocumentBooleanSchema {
  const DocumentAgreementConfirmationSchema({
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
  });

  @override
  DocumentAgreementConfirmationSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentAgreementConfirmationSchema(
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
    );
  }
}

final class DocumentGenericBooleanSchema extends DocumentBooleanSchema {
  const DocumentGenericBooleanSchema({
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
  });

  const DocumentGenericBooleanSchema.optional({
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
  });

  @override
  DocumentGenericBooleanSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericBooleanSchema(
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
    );
  }
}
