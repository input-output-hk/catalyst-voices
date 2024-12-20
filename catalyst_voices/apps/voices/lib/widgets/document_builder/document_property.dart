import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentPropertyWidget extends StatelessWidget {
  final BaseDocumentDefinition definition;
  const DocumentPropertyWidget({super.key, required this.definition});

  @override
  Widget build(BuildContext context) {
    return switch (definition) {
      SegmentDefinition() => throw UnimplementedError(),
      SectionDefinition() => throw UnimplementedError(),
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
      AgreementConfirmationDefinition() => throw UnimplementedError(),
      SPDXLicenceOrUrlDefinition() => throw UnimplementedError(),
    };
  }
}
