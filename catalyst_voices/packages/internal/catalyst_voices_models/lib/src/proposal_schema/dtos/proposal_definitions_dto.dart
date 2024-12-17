import 'package:catalyst_voices_models/src/proposal_schema/proposal_definitions.dart';
import 'package:json_annotation/json_annotation.dart';
part 'proposal_definitions_dto.g.dart';

@JsonSerializable()
class ProposalDefinitionsDTO {
  final SegmentDTO segment;
  final SectionDTO section;
  final SingleLineTextEntryDTO singleLineTextEntry;
  final SingleLineHttpsURLEntryDTO singleLineHttpsURLEntry;
  final MultiLineTextEntryDTO multiLineTextEntry;
  final MultiLineTextEntryMarkdownDTO multiLineTextEntryMarkdown;
  final DropDownSingleSelectDTO dropDownSingleSelect;
  final MultiSelectDTO multiSelect;
  final SingleLineTextEntryListDTO singleLineTextEntryList;
  final MultiLineTextEntryListMarkdownDTO multiLineTextEntryListMarkdown;
  final SingleLineHttpsURLEntryListDTO singleLineHttpsURLEntryList;
  final NestedQuestionsListDTO nestedQuestionsList;
  final NestedQuestionsDTO nestedQuestions;
  final SingleGroupedTagSelectorDTO singleGroupedTagSelector;
  final TagGroupDTO tagGroup;
  final TagSelectionDTO tagSelection;
  @JsonKey(name: 'tokenValueCardanoADA')
  final TokenValueCardanoAdaDTO tokenValueCardanoAda;
  final DurationInMonthsDTO durationInMonths;
  final YesNoChoiceDTO yesNoChoice;
  final AgreementConfirmationDTO agreementConfirmation;
  @JsonKey(name: 'spdxLicenseOrURL')
  final SPDXLicenceOrUrlDTO spdxLicenceOrUrl;

  const ProposalDefinitionsDTO({
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
  });

  factory ProposalDefinitionsDTO.fromJson(Map<String, dynamic> json) =>
      _$ProposalDefinitionsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProposalDefinitionsDTOToJson(this);

  ProposalDefinitions toModel() {
    return ProposalDefinitions(
      segmentDefinition: segment.toModel(),
      sectionDefinition: section.toModel(),
      singleLineTextEntryDefinition: singleLineTextEntry.toModel(),
    );
  }
}

@JsonSerializable()
class SegmentDTO {
  final String type;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const SegmentDTO({
    required this.type,
    required this.additionalProperties,
    required this.note,
  });

  factory SegmentDTO.fromJson(Map<String, dynamic> json) =>
      _$SegmentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentDTOToJson(this);

  SegmentProposalDefinition toModel() => SegmentProposalDefinition(
        type: DefinitionsObjectTypes.fromString(type),
        note: note,
        additionalProperties: additionalProperties,
      );
}

@JsonSerializable()
class SectionDTO {
  final String type;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const SectionDTO({
    required this.type,
    required this.additionalProperties,
    required this.note,
  });

  factory SectionDTO.fromJson(Map<String, dynamic> json) =>
      _$SectionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SectionDTOToJson(this);

  SectionProposalDefinition toModel() => SectionProposalDefinition(
        type: DefinitionsObjectTypes.fromString(type),
        note: note,
        additionalProperties: additionalProperties,
      );
}

@JsonSerializable()
class SingleLineTextEntryDTO {
  final String type;
  final String contentMediaType;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineTextEntryDTO({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.note,
  });

  factory SingleLineTextEntryDTO.fromJson(Map<String, dynamic> json) =>
      _$SingleLineTextEntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineTextEntryDTOToJson(this);

  SingleLineTextEntryDefinition toModel() => SingleLineTextEntryDefinition(
        type: DefinitionsObjectTypes.fromString(type),
        note: note,
        contentMediaType:
            DefinitionsContentMediaType.fromString(contentMediaType),
        pattern: pattern,
      );
}

@JsonSerializable()
class SingleLineHttpsURLEntryDTO {
  final String type;
  final String format;
  final String pattern;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineHttpsURLEntryDTO({
    required this.type,
    required this.format,
    required this.pattern,
    required this.note,
  });

  factory SingleLineHttpsURLEntryDTO.fromJson(Map<String, dynamic> json) =>
      _$SingleLineHttpsURLEntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineHttpsURLEntryDTOToJson(this);
}

@JsonSerializable()
class MultiLineTextEntryDTO {
  final String type;
  final String contentMediaType;
  final String pattern;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiLineTextEntryDTO({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.format,
    required this.note,
  });

  factory MultiLineTextEntryDTO.fromJson(Map<String, dynamic> json) =>
      _$MultiLineTextEntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MultiLineTextEntryDTOToJson(this);
}

@JsonSerializable()
class MultiLineTextEntryMarkdownDTO {
  final String type;
  final String contentMediaType;
  final String pattern;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiLineTextEntryMarkdownDTO({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.format,
    required this.note,
  });

  factory MultiLineTextEntryMarkdownDTO.fromJson(Map<String, dynamic> json) =>
      _$MultiLineTextEntryMarkdownDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MultiLineTextEntryMarkdownDTOToJson(this);
}

@JsonSerializable()
class DropDownSingleSelectDTO {
  final String type;
  final String contentMediaType;
  final String pattern;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const DropDownSingleSelectDTO({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.format,
    required this.note,
  });

  factory DropDownSingleSelectDTO.fromJson(Map<String, dynamic> json) =>
      _$DropDownSingleSelectDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DropDownSingleSelectDTOToJson(this);
}

@JsonSerializable()
class MultiSelectDTO {
  final String type;
  final String contentMediaType;
  final String pattern;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiSelectDTO({
    required this.type,
    required this.contentMediaType,
    required this.pattern,
    required this.format,
    required this.note,
  });

  factory MultiSelectDTO.fromJson(Map<String, dynamic> json) =>
      _$MultiSelectDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MultiSelectDTOToJson(this);
}

@JsonSerializable()
class SingleLineTextEntryListDTO {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  final List<dynamic> defaultValue;
  final Map<String, dynamic> items;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineTextEntryListDTO({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
    required this.note,
  });

  factory SingleLineTextEntryListDTO.fromJson(Map<String, dynamic> json) =>
      _$SingleLineTextEntryListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineTextEntryListDTOToJson(this);
}

@JsonSerializable()
class MultiLineTextEntryListMarkdownDTO {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  final List<dynamic> defaultValue;
  final Map<String, dynamic> items;
  @JsonKey(name: 'x-note')
  final String note;

  const MultiLineTextEntryListMarkdownDTO({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
    required this.note,
  });

  factory MultiLineTextEntryListMarkdownDTO.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MultiLineTextEntryListMarkdownDTOFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MultiLineTextEntryListMarkdownDTOToJson(this);
}

@JsonSerializable()
class SingleLineHttpsURLEntryListDTO {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  final List<dynamic> defaultValue;
  final Map<String, dynamic> items;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleLineHttpsURLEntryListDTO({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
    required this.note,
  });

  factory SingleLineHttpsURLEntryListDTO.fromJson(Map<String, dynamic> json) =>
      _$SingleLineHttpsURLEntryListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SingleLineHttpsURLEntryListDTOToJson(this);
}

@JsonSerializable()
class NestedQuestionsListDTO {
  final String type;
  final String format;
  final bool uniqueItems;
  @JsonKey(name: 'default')
  final List<dynamic> defaultValue;
  @JsonKey(name: 'x-note')
  final String note;

  const NestedQuestionsListDTO({
    required this.type,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.note,
  });

  factory NestedQuestionsListDTO.fromJson(Map<String, dynamic> json) =>
      _$NestedQuestionsListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NestedQuestionsListDTOToJson(this);
}

@JsonSerializable()
class NestedQuestionsDTO {
  final String type;
  final String format;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const NestedQuestionsDTO({
    required this.type,
    required this.format,
    required this.additionalProperties,
    required this.note,
  });

  factory NestedQuestionsDTO.fromJson(Map<String, dynamic> json) =>
      _$NestedQuestionsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NestedQuestionsDTOToJson(this);
}

@JsonSerializable()
class SingleGroupedTagSelectorDTO {
  final String type;
  final String format;
  final bool additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const SingleGroupedTagSelectorDTO({
    required this.type,
    required this.format,
    required this.additionalProperties,
    required this.note,
  });

  factory SingleGroupedTagSelectorDTO.fromJson(Map<String, dynamic> json) =>
      _$SingleGroupedTagSelectorDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SingleGroupedTagSelectorDTOToJson(this);
}

@JsonSerializable()
class TagGroupDTO {
  final String type;
  final String format;
  final String additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const TagGroupDTO({
    required this.type,
    required this.format,
    required this.additionalProperties,
    required this.note,
  });

  factory TagGroupDTO.fromJson(Map<String, dynamic> json) =>
      _$TagGroupDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TagGroupDTOToJson(this);
}

@JsonSerializable()
class TagSelectionDTO {
  final String type;
  final String format;
  final String additionalProperties;
  @JsonKey(name: 'x-note')
  final String note;

  const TagSelectionDTO({
    required this.type,
    required this.format,
    required this.additionalProperties,
    required this.note,
  });

  factory TagSelectionDTO.fromJson(Map<String, dynamic> json) =>
      _$TagSelectionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TagSelectionDTOToJson(this);
}

@JsonSerializable()
class TokenValueCardanoAdaDTO {
  final String type;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const TokenValueCardanoAdaDTO({
    required this.type,
    required this.format,
    required this.note,
  });

  factory TokenValueCardanoAdaDTO.fromJson(Map<String, dynamic> json) =>
      _$TokenValueCardanoAdaDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TokenValueCardanoAdaDTOToJson(this);
}

@JsonSerializable()
class DurationInMonthsDTO {
  final String type;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const DurationInMonthsDTO({
    required this.type,
    required this.format,
    required this.note,
  });

  factory DurationInMonthsDTO.fromJson(Map<String, dynamic> json) =>
      _$DurationInMonthsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DurationInMonthsDTOToJson(this);
}

@JsonSerializable()
class YesNoChoiceDTO {
  final String type;
  final String format;
  @JsonKey(name: 'default')
  final bool defaultValue;
  @JsonKey(name: 'x-note')
  final String note;

  const YesNoChoiceDTO({
    required this.type,
    required this.format,
    required this.defaultValue,
    required this.note,
  });

  factory YesNoChoiceDTO.fromJson(Map<String, dynamic> json) =>
      _$YesNoChoiceDTOFromJson(json);

  Map<String, dynamic> toJson() => _$YesNoChoiceDTOToJson(this);
}

@JsonSerializable()
class AgreementConfirmationDTO {
  final String type;
  final String format;
  @JsonKey(name: 'default')
  final bool defaultValue;
  @JsonKey(name: 'const')
  final bool constValue;
  @JsonKey(name: 'x-note')
  final String note;

  const AgreementConfirmationDTO({
    required this.type,
    required this.format,
    required this.defaultValue,
    required this.constValue,
    required this.note,
  });

  factory AgreementConfirmationDTO.fromJson(Map<String, dynamic> json) =>
      _$AgreementConfirmationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementConfirmationDTOToJson(this);
}

@JsonSerializable()
class SPDXLicenceOrUrlDTO {
  final String type;
  final String contentMediaType;
  final String additionalProperties;
  final String format;
  @JsonKey(name: 'x-note')
  final String note;

  const SPDXLicenceOrUrlDTO({
    required this.type,
    required this.contentMediaType,
    required this.additionalProperties,
    required this.format,
    required this.note,
  });

  factory SPDXLicenceOrUrlDTO.fromJson(Map<String, dynamic> json) =>
      _$SPDXLicenceOrUrlDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SPDXLicenceOrUrlDTOToJson(this);
}
