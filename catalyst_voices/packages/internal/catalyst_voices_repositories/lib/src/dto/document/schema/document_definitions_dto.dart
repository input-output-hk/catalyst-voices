import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_definitions_dto.g.dart';

@JsonSerializable()
final class DocumentDefinitionsDto {
  final SegmentDto segment;
  final SectionDto section;
  final SingleLineTextEntryDto singleLineTextEntry;
  final SingleLineHttpsURLEntryDto singleLineHttpsURLEntry;
  final MultiLineTextEntryDto multiLineTextEntry;
  final MultiLineTextEntryMarkdownDto multiLineTextEntryMarkdown;
  final DropDownSingleSelectDto dropDownSingleSelect;
  final MultiSelectDto multiSelect;
  final SingleLineTextEntryListDto singleLineTextEntryList;
  final MultiLineTextEntryListMarkdownDto multiLineTextEntryListMarkdown;
  final SingleLineHttpsURLEntryListDto singleLineHttpsURLEntryList;
  final NestedQuestionsListDto nestedQuestionsList;
  final NestedQuestionsDto nestedQuestions;
  final SingleGroupedTagSelectorDto singleGroupedTagSelector;
  final TagGroupDto tagGroup;
  final TagSelectionDto tagSelection;
  @JsonKey(name: 'tokenValueCardanoADA')
  final TokenValueCardanoAdaDto tokenValueCardanoAda;
  final DurationInMonthsDto durationInMonths;
  final YesNoChoiceDto yesNoChoice;
  final AgreementConfirmationDto agreementConfirmation;
  @JsonKey(name: 'spdxLicenseOrURL')
  final SPDXLicenceOrUrlDto spdxLicenceOrUrl;
  final LanguageCodeDto languageCode;

  const DocumentDefinitionsDto({
    required this.segment,
    required this.section,
    required this.singleLineTextEntry,
    required this.singleLineHttpsURLEntry,
    required this.multiLineTextEntry,
    required this.multiLineTextEntryMarkdown,
    required this.dropDownSingleSelect,
    required this.multiSelect,
    required this.singleLineTextEntryList,
    required this.multiLineTextEntryListMarkdown,
    required this.singleLineHttpsURLEntryList,
    required this.nestedQuestionsList,
    required this.nestedQuestions,
    required this.singleGroupedTagSelector,
    required this.tagGroup,
    required this.tagSelection,
    required this.tokenValueCardanoAda,
    required this.durationInMonths,
    required this.yesNoChoice,
    required this.agreementConfirmation,
    required this.spdxLicenceOrUrl,
    required this.languageCode,
  });

  factory DocumentDefinitionsDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentDefinitionsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentDefinitionsDtoToJson(this);

  List<BaseDocumentDefinition> get models => [
        segment.toModel(),
        section.toModel(),
        singleLineTextEntry.toModel(),
        multiLineTextEntry.toModel(),
        multiLineTextEntryMarkdown.toModel(),
        dropDownSingleSelect.toModel(),
        multiSelect.toModel(),
        singleLineTextEntryList.toModel(),
        multiLineTextEntryListMarkdown.toModel(),
        singleLineHttpsURLEntry.toModel(),
        singleLineHttpsURLEntryList.toModel(),
        nestedQuestionsList.toModel(),
        nestedQuestions.toModel(),
        singleGroupedTagSelector.toModel(),
        tagGroup.toModel(),
        tagSelection.toModel(),
        tokenValueCardanoAda.toModel(),
        durationInMonths.toModel(),
        yesNoChoice.toModel(),
        agreementConfirmation.toModel(),
        spdxLicenceOrUrl.toModel(),
        languageCode.toModel(),
      ];
}

@JsonSerializable()
final class SegmentDto {
  final String type;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const SegmentDto({
    required this.type,
    required this.additionalProperties,
    required this.note,
  });

  factory SegmentDto.fromJson(Map<String, dynamic> json) =>
      _$SegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentDtoToJson(this);

  SegmentDefinition toModel() => SegmentDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        additionalProperties: additionalProperties,
      );
}

@JsonSerializable()
final class SectionDto {
  final String type;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const SectionDto({
    required this.type,
    required this.additionalProperties,
    required this.note,
  });

  factory SectionDto.fromJson(Map<String, dynamic> json) =>
      _$SectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SectionDtoToJson(this);

  SectionDefinition toModel() => SectionDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        additionalProperties: additionalProperties,
      );
}

@JsonSerializable()
class SingleLineTextEntryDto {
  final String type;
  final String contentMediaType;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineTextEntryDto({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.note,
  });

  factory SingleLineTextEntryDto.fromJson(Map<String, dynamic> json) =>
      _$SingleLineTextEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineTextEntryDtoToJson(this);

  SingleLineTextEntryDefinition toModel() => SingleLineTextEntryDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        contentMediaType:
            DocumentDefinitionsContentMediaType.fromString(contentMediaType),
        pattern: pattern,
      );
}

@JsonSerializable()
final class SingleLineHttpsURLEntryDto {
  final String type;
  final String format;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineHttpsURLEntryDto({
    required this.type,
    required this.format,
    required this.pattern,
    required this.note,
  });

  factory SingleLineHttpsURLEntryDto.fromJson(Map<String, dynamic> json) =>
      _$SingleLineHttpsURLEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineHttpsURLEntryDtoToJson(this);

  SingleLineHttpsURLEntryDefinition toModel() {
    return SingleLineHttpsURLEntryDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
      pattern: pattern,
    );
  }
}

@JsonSerializable()
final class MultiLineTextEntryDto {
  final String type;
  final String contentMediaType;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiLineTextEntryDto({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.note,
  });

  factory MultiLineTextEntryDto.fromJson(Map<String, dynamic> json) =>
      _$MultiLineTextEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MultiLineTextEntryDtoToJson(this);

  MultiLineTextEntryDefinition toModel() {
    return MultiLineTextEntryDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      contentMediaType:
          DocumentDefinitionsContentMediaType.fromString(contentMediaType),
      pattern: pattern,
    );
  }
}

@JsonSerializable()
final class MultiLineTextEntryMarkdownDto {
  final String type;
  final String contentMediaType;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiLineTextEntryMarkdownDto({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.note,
  });

  factory MultiLineTextEntryMarkdownDto.fromJson(Map<String, dynamic> json) =>
      _$MultiLineTextEntryMarkdownDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MultiLineTextEntryMarkdownDtoToJson(this);

  MultiLineTextEntryMarkdownDefinition toModel() {
    return MultiLineTextEntryMarkdownDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      contentMediaType:
          DocumentDefinitionsContentMediaType.fromString(contentMediaType),
      pattern: pattern,
    );
  }
}

@JsonSerializable()
final class DropDownSingleSelectDto {
  final String type;
  final String contentMediaType;
  final String pattern;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const DropDownSingleSelectDto({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.format,
    required this.note,
  });

  factory DropDownSingleSelectDto.fromJson(Map<String, dynamic> json) =>
      _$DropDownSingleSelectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DropDownSingleSelectDtoToJson(this);

  DropDownSingleSelectDefinition toModel() {
    return DropDownSingleSelectDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      contentMediaType:
          DocumentDefinitionsContentMediaType.fromString(contentMediaType),
      pattern: pattern,
      format: DocumentDefinitionsFormat.fromString(format),
    );
  }
}

@JsonSerializable()
final class MultiSelectDto {
  final String type;
  final bool uniqueItems;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiSelectDto({
    required this.type,
    required this.uniqueItems,
    required this.format,
    required this.note,
  });

  factory MultiSelectDto.fromJson(Map<String, dynamic> json) =>
      _$MultiSelectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MultiSelectDtoToJson(this);

  MultiSelectDefinition toModel() {
    return MultiSelectDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
      uniqueItems: uniqueItems,
    );
  }
}

@JsonSerializable()
final class SingleLineTextEntryListDto {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  @ListStringConverter()
  final List<String>? defaultValue;
  final Map<String, dynamic> items;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineTextEntryListDto({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
    required this.note,
  });

  factory SingleLineTextEntryListDto.fromJson(Map<String, dynamic> json) =>
      _$SingleLineTextEntryListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineTextEntryListDtoToJson(this);

  SingleLineTextEntryListDefinition toModel() =>
      SingleLineTextEntryListDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        uniqueItems: uniqueItems,
        defaultValues: defaultValue ?? <String>[],
        items: items,
      );
}

@JsonSerializable()
final class MultiLineTextEntryListMarkdownDto {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  @ListStringConverter()
  final List<String>? defaultValue;
  final Map<String, dynamic> items;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiLineTextEntryListMarkdownDto({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
    required this.note,
  });

  factory MultiLineTextEntryListMarkdownDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MultiLineTextEntryListMarkdownDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MultiLineTextEntryListMarkdownDtoToJson(this);

  MultiLineTextEntryListMarkdownDefinition toModel() =>
      MultiLineTextEntryListMarkdownDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        uniqueItems: uniqueItems,
        defaultValue: defaultValue ?? <String>[],
        items: items,
      );
}

@JsonSerializable()
final class SingleLineHttpsURLEntryListDto {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  @ListStringConverter()
  final List<String>? defaultValue;
  final Map<String, dynamic> items;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineHttpsURLEntryListDto({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
    required this.note,
  });

  factory SingleLineHttpsURLEntryListDto.fromJson(Map<String, dynamic> json) =>
      _$SingleLineHttpsURLEntryListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineHttpsURLEntryListDtoToJson(this);

  SingleLineHttpsURLEntryListDefinition toModel() =>
      SingleLineHttpsURLEntryListDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        uniqueItems: uniqueItems,
        defaultValue: defaultValue ?? <String>[],
        items: items,
      );
}

@JsonSerializable()
final class NestedQuestionsListDto {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  @ListStringConverter()
  final List<String>? defaultValue;
  @JsonKey(name: 'x-note')
  final String note;

  const NestedQuestionsListDto({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.note,
  });

  factory NestedQuestionsListDto.fromJson(Map<String, dynamic> json) =>
      _$NestedQuestionsListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NestedQuestionsListDtoToJson(this);

  NestedQuestionsListDefinition toModel() => NestedQuestionsListDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        uniqueItems: uniqueItems,
        defaultValue: defaultValue ?? <String>[],
      );
}

@JsonSerializable()
final class NestedQuestionsDto {
  final String type;
  final String format;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const NestedQuestionsDto({
    required this.type,
    required this.format,
    required this.additionalProperties,
    required this.note,
  });

  factory NestedQuestionsDto.fromJson(Map<String, dynamic> json) =>
      _$NestedQuestionsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NestedQuestionsDtoToJson(this);

  NestedQuestionsDefinition toModel() {
    return NestedQuestionsDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
      additionalProperties: additionalProperties,
    );
  }
}

@JsonSerializable()
final class SingleGroupedTagSelectorDto {
  final String type;
  final String format;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleGroupedTagSelectorDto({
    required this.type,
    required this.format,
    required this.additionalProperties,
    required this.note,
  });

  factory SingleGroupedTagSelectorDto.fromJson(Map<String, dynamic> json) =>
      _$SingleGroupedTagSelectorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleGroupedTagSelectorDtoToJson(this);

  SingleGroupedTagSelectorDefinition toModel() {
    return SingleGroupedTagSelectorDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
      additionalProperties: additionalProperties,
    );
  }
}

@JsonSerializable()
final class TagGroupDto {
  final String type;
  final String format;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const TagGroupDto({
    required this.type,
    required this.format,
    required this.pattern,
    required this.note,
  });

  factory TagGroupDto.fromJson(Map<String, dynamic> json) =>
      _$TagGroupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TagGroupDtoToJson(this);

  TagGroupDefinition toModel() {
    return TagGroupDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
      pattern: pattern,
    );
  }
}

@JsonSerializable()
final class TagSelectionDto {
  final String type;
  final String format;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const TagSelectionDto({
    required this.type,
    required this.format,
    required this.pattern,
    required this.note,
  });

  factory TagSelectionDto.fromJson(Map<String, dynamic> json) =>
      _$TagSelectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TagSelectionDtoToJson(this);

  TagSelectionDefinition toModel() {
    return TagSelectionDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
      pattern: pattern,
    );
  }
}

@JsonSerializable()
final class TokenValueCardanoAdaDto {
  final String type;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const TokenValueCardanoAdaDto({
    required this.type,
    required this.format,
    required this.note,
  });

  factory TokenValueCardanoAdaDto.fromJson(Map<String, dynamic> json) =>
      _$TokenValueCardanoAdaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenValueCardanoAdaDtoToJson(this);

  TokenValueCardanoADADefinition toModel() => TokenValueCardanoADADefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
      );
}

@JsonSerializable()
final class DurationInMonthsDto {
  final String type;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const DurationInMonthsDto({
    required this.type,
    required this.format,
    required this.note,
  });

  factory DurationInMonthsDto.fromJson(Map<String, dynamic> json) =>
      _$DurationInMonthsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DurationInMonthsDtoToJson(this);

  DurationInMonthsDefinition toModel() {
    return DurationInMonthsDefinition(
      type: DocumentDefinitionsObjectType.fromString(type),
      note: note,
      format: DocumentDefinitionsFormat.fromString(format),
    );
  }
}

@JsonSerializable()
final class YesNoChoiceDto {
  final String type;
  final String format;
  @JsonKey(name: 'default')
  final bool? defaultValue;
  @JsonKey(name: 'x-note')
  final String note;

  const YesNoChoiceDto({
    required this.type,
    required this.format,
    required this.defaultValue,
    required this.note,
  });

  factory YesNoChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$YesNoChoiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YesNoChoiceDtoToJson(this);

  YesNoChoiceDefinition toModel() => YesNoChoiceDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        defaultValue: defaultValue ?? false,
      );
}

@JsonSerializable()
final class AgreementConfirmationDto {
  final String type;
  final String format;
  @JsonKey(name: 'default')
  final bool? defaultValue;
  @JsonKey(name: 'const')
  final bool? constValue;
  @JsonKey(name: 'x-note')
  final String note;

  const AgreementConfirmationDto({
    required this.type,
    required this.format,
    required this.defaultValue,
    required this.constValue,
    required this.note,
  });

  factory AgreementConfirmationDto.fromJson(Map<String, dynamic> json) =>
      _$AgreementConfirmationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementConfirmationDtoToJson(this);

  AgreementConfirmationDefinition toModel() => AgreementConfirmationDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        defaultValue: defaultValue ?? false,
        constValue: constValue ?? true,
      );
}

@JsonSerializable()
final class SPDXLicenceOrUrlDto {
  final String type;
  final String contentMediaType;
  final String pattern;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const SPDXLicenceOrUrlDto({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.format,
    required this.note,
  });

  factory SPDXLicenceOrUrlDto.fromJson(Map<String, dynamic> json) =>
      _$SPDXLicenceOrUrlDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SPDXLicenceOrUrlDtoToJson(this);

  SPDXLicenceOrUrlDefinition toModel() => SPDXLicenceOrUrlDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        format: DocumentDefinitionsFormat.fromString(format),
        pattern: pattern,
        contentMediaType:
            DocumentDefinitionsContentMediaType.fromString(contentMediaType),
      );
}

@JsonSerializable()
final class LanguageCodeDto {
  final String type;
  final String? title;
  final String? description;
  @JsonKey(name: 'enum')
  @ListStringConverter()
  final List<String>? enumValues;
  @JsonKey(name: 'default')
  final String? defaultValue;
  @JsonKey(name: 'x-note')
  final String note;

  const LanguageCodeDto({
    required this.type,
    required this.title,
    required this.description,
    required this.enumValues,
    required this.defaultValue,
    required this.note,
  });

  factory LanguageCodeDto.fromJson(Map<String, dynamic> json) =>
      _$LanguageCodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageCodeDtoToJson(this);

  LanguageCodeDefinition toModel() => LanguageCodeDefinition(
        type: DocumentDefinitionsObjectType.fromString(type),
        note: note,
        defaultValue: defaultValue ?? 'en',
        enumValues: enumValues ?? <String>[],
      );
}
