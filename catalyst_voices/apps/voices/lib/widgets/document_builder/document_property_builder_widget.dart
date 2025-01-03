import 'package:catalyst_voices/widgets/document_builder/agreement_confirmation_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentProperty] in editing (builder) mode.
class DocumentPropertyBuilderWidget extends StatelessWidget {
  /// A single field of the document that belongs to a section.
  final DocumentProperty property;

  /// A callback that should be called with the latest [DocumentChange]
  /// for the edited [property] when the user wants to save the changes.
  final ValueChanged<DocumentChange> onChanged;

  const DocumentPropertyBuilderWidget({
    super.key,
    required this.property,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final definition = property.schema.definition;
    return switch (definition) {
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
      TokenValueCardanoADADefinition() => throw UnimplementedError(),
      DurationInMonthsDefinition() => throw UnimplementedError(),
      YesNoChoiceDefinition() => throw UnimplementedError(),
      AgreementConfirmationDefinition() => AgreementConfirmationTile(
          definition: definition,
          value: definition.castProperty(property).value,
          nodeId: property.schema.nodeId,
          title: property.schema.title ?? '',
          description: property.schema.description ?? '',
          isSelected: true,
          onChanged: onChanged,
        ),
      SPDXLicenceOrUrlDefinition() => throw UnimplementedError(),
      LanguageCodeDefinition() => throw UnimplementedError(),

      // unsupported
      SegmentDefinition() || SectionDefinition() => throw UnsupportedError(
          '${property.schema.definition} unsupported '
          'by $DocumentPropertyBuilderWidget',
        ),
    };
  }
}
