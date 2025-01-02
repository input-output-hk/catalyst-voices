import 'package:catalyst_voices/widgets/document_builder/document_token_value_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentProperty] in editing (builder) mode.
class DocumentPropertyBuilderWidget extends StatelessWidget {
  /// A single field of the document that belongs to a section.
  final DocumentProperty property;

  // TODO(damian-molinski): Should come from SectionsController in context
  // of ProposalBuilder.
  /// Whether this property should be highlighted as selected.
  final bool isSelected;

  /// A callback that should be called with the latest [DocumentChange]
  /// for the edited [property] when the user wants to save the changes.
  final ValueChanged<DocumentChange> onChanged;

  const DocumentPropertyBuilderWidget({
    super.key,
    required this.property,
    this.isSelected = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return switch (property.schema.definition) {
      SingleLineTextEntryDefinition() => throw UnimplementedError(),
      SingleLineHttpsURLEntryDefinition() => throw UnimplementedError(),
      MultiLineTextEntryDefinition() => throw UnimplementedError(),
      MultiLineTextEntryMarkdownDefinition() => throw UnimplementedError(),
      DropDownSingleSelectDefinition() => throw UnimplementedError(),
      MultiSelectDefinition() => throw UnimplementedError(),
      SingleLineTextEntryListDefinition() => throw UnimplementedError(),
      MultiLineTextEntryListMarkdownDefinition() => throw UnimplementedError(),
      SingleLineHttpsURLEntryListDefinition() => throw UnimplementedError(),
      NestedQuestionsListDefinition() => throw UnimplementedError(),
      NestedQuestionsDefinition() => throw UnimplementedError(),
      SingleGroupedTagSelectorDefinition() => throw UnimplementedError(),
      TagGroupDefinition() => throw UnimplementedError(),
      TagSelectionDefinition() => throw UnimplementedError(),
      TokenValueCardanoADADefinition() => DocumentTokenValueTile(
          key: ObjectKey(property.schema.nodeId),
          id: property.schema.nodeId,
          title: property.schema.title,
          description: property.schema.description,
          initialValue: property.value is int ? property.value! as int : null,
          currency: const Currency.ada(),
          range: property.schema.range,
          isSelected: isSelected,
          isRequired: property.schema.isRequired,
          onChanged: onChanged,
        ),
      DurationInMonthsDefinition() => throw UnimplementedError(),
      YesNoChoiceDefinition() => throw UnimplementedError(),
      AgreementConfirmationDefinition() => throw UnimplementedError(),
      SPDXLicenceOrUrlDefinition() => throw UnimplementedError(),

      // unsupported
      SegmentDefinition() || SectionDefinition() => throw UnsupportedError(
          '${property.schema.definition} unsupported '
          'by $DocumentPropertyBuilderWidget',
        ),
    };
  }
}
