part of '../document_definitions.dart';

final class SingleGroupedTagSelectorDefinition
    extends BaseDocumentDefinition<GroupedTagsSelection> {
  final DocumentDefinitionsFormat format;
  final bool additionalProperties;

  const SingleGroupedTagSelectorDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });

  @visibleForTesting
  const SingleGroupedTagSelectorDefinition.dummy()
      : this(
          type: DocumentDefinitionsObjectType.object,
          note: '',
          format: DocumentDefinitionsFormat.singleGroupedTagSelector,
          additionalProperties: true,
        );

  @override
  DocumentValidationResult validateProperty(
    DocumentProperty<GroupedTagsSelection> property,
  ) {
    final result = DocumentValidator.validateBasic(property);
    if (result.isInvalid) {
      return result;
    }

    final value = property.value;
    if (value == null) {
      // whether the property is required or not is validated by the
      // validateBasic since it passed the validation the property
      // is not required
      return const SuccessfulDocumentValidation();
    }

    // TODO(dtscalac): validate whether group & tag are oneOf
    // specified by the schema
    if (value.isValid) {
      return const SuccessfulDocumentValidation();
    } else {
      return MissingRequiredDocumentValue(
        invalidNodeId: property.schema.nodeId,
      );
    }
  }

  List<GroupedTags> groupedTags(
    DocumentSchemaProperty<GroupedTagsSelection> schema,
  ) {
    assert(
      schema.definition is SingleGroupedTagSelectorDefinition,
      'Grouped tags are available only for SingleGroupedTagSelector',
    );

    final oneOf = schema.oneOf ?? const [];
    return GroupedTags.fromLogicalGroups(oneOf);
  }

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];
}
