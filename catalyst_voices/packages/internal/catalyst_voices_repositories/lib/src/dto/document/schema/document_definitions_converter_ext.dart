import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/defined_property_dto/grouped_tags_dto.dart';
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
      case NestedQuestionsDefinition():
      case TagGroupDefinition():
      case TagSelectionDefinition():
      case TokenValueCardanoADADefinition():
      case DurationInMonthsDefinition():
      case YesNoChoiceDefinition():
      case AgreementConfirmationDefinition():
      case SPDXLicenceOrUrlDefinition():
      case LanguageCodeDefinition():
      case SegmentDefinition():
      case SectionDefinition():
        return NoopConverter<T>();
      case SingleGroupedTagSelectorDefinition():
        return const GroupedTagsSelectionConverter()
            as JsonConverter<T?, Object?>;
      case SingleLineTextEntryListDefinition():
      case MultiLineTextEntryListMarkdownDefinition():
      case SingleLineHttpsURLEntryListDefinition():
        return const ListStringConverter() as JsonConverter<T?, Object?>;
      case NestedQuestionsListDefinition():
        return const ListOfJsonConverter() as JsonConverter<T?, Object?>;
    }
  }
}
