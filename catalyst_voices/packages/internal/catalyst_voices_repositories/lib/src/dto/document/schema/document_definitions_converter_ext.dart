import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/defined_property_dto/grouped_tags_dto.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

extension DocumentPropertySchemaConverterExt<T extends Object>
    on DocumentPropertySchema {
  JsonConverter<T?, Object?> get converter {
    switch (this) {
      case DocumentNestedQuestionsListSchema():
        return const ListOfJsonConverter() as JsonConverter<T?, Object?>;

      case DocumentMultiSelectSchema():
      case DocumentSingleLineTextEntryListSchema():
      case DocumentMultiLineTextEntryListMarkdownSchema():
      case DocumentSingleLineHttpsUrlEntryListSchema():
        return const ListStringConverter() as JsonConverter<T?, Object?>;

      case DocumentSingleGroupedTagSelectorSchema():
        return const GroupedTagsSelectionConverter()
            as JsonConverter<T?, Object?>;

      case DocumentGenericListSchema():
      case DocumentSegmentSchema():
      case DocumentSectionSchema():
      case DocumentNestedQuestionsSchema():
      case DocumentGenericObjectSchema():
      case DocumentSingleLineTextEntrySchema():
      case DocumentSingleLineHttpsUrlEntrySchema():
      case DocumentMultiLineTextEntrySchema():
      case DocumentMultiLineTextEntryMarkdownSchema():
      case DocumentDropDownSingleSelectSchema():
      case DocumentTagGroupSchema():
      case DocumentTagSelectionSchema():
      case DocumentSpdxLicenseOrUrlSchema():
      case DocumentLanguageCodeSchema():
      case DocumentGenericStringSchema():
      case DocumentTokenValueCardanoAdaSchema():
      case DocumentDurationInMonthsSchema():
      case DocumentGenericIntegerSchema():
      case DocumentGenericNumberSchema():
      case DocumentYesNoChoiceSchema():
      case DocumentAgreementConfirmationSchema():
      case DocumentGenericBooleanSchema():
        return NoopConverter<T>();
    }
  }
}
