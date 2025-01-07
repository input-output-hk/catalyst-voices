part of 'document_definitions.dart';

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
    // TODO(dtscalac): validation
    // bool get isValid => group != null && tag != null;

    return DocumentValidator.validateBasic(property);
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
