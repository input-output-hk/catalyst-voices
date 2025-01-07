import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

extension DocumentDefinitionConverterExt<T extends Object>
    on BaseDocumentDefinition<T> {
  JsonConverter<T?, Object?> get converter {
    switch (this) {
      case SingleLineTextEntryDefinition():
      case SingleLineHttpsURLEntryDefinition():
      case MultiLineTextEntryDefinition():
      case MultiLineTextEntryMarkdownDefinition():
      case DropDownSingleSelectDefinition():
      case MultiSelectDefinition():
      case MultiLineTextEntryListMarkdownDefinition():
      case SingleLineHttpsURLEntryListDefinition():
      case NestedQuestionsListDefinition():
      case NestedQuestionsDefinition():
      case SingleGroupedTagSelectorDefinition():
      case TagGroupDefinition():
      case TagSelectionDefinition():
      case TokenValueCardanoADADefinition():
      case DurationInMonthsDefinition():
      case YesNoChoiceDefinition():
      case AgreementConfirmationDefinition():
      case SPDXLicenceOrUrlDefinition():
      case LanguageCodeDefinition():
        return NoopConverter<T>();
      case SingleLineTextEntryListDefinition():
        return const ListStringConverter() as JsonConverter<T?, Object?>;
      case SegmentDefinition():
      case SectionDefinition():
        throw UnsupportedError("These definitions don't support values");
    }
  }
}
