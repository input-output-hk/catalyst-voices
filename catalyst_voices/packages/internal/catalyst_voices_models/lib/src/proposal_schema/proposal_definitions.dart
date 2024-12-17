enum DefinitionsObjectTypes {
  string,
  object,
  integer,
  array,
  unknown;

  const DefinitionsObjectTypes();

  static DefinitionsObjectTypes fromString(String value) {
    return DefinitionsObjectTypes.values.firstWhere(
      (type) => type.name == value,
      orElse: () => DefinitionsObjectTypes.unknown,
    );
  }
}

enum DefinitionsContentMediaType {
  textPlain('text/plain'),
  markdown('text/markdown'),
  unknown('unknown');

  final String value;

  const DefinitionsContentMediaType(this.value);

  static DefinitionsContentMediaType fromString(String value) {
    return DefinitionsContentMediaType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => DefinitionsContentMediaType.unknown,
    );
  }
}

enum DefinitionsFormats {
  singleLineTextEntry,
  multiLineTextEntry,
  multiLineTextEntryMarkdown,
  dropDownSingleSelect,
  multiSelect,
  singleLineHttpsURLEntry,
  nestedQuestions,
  nestedQuestionsList,
  singleGroupedTagSelector,
  tagGroup,
  tagSelection,
  tokenValueCardanoADA,
  durationInMonths,
  yesNoChoice,
  agreementConfirmation,
  spdxLicenseOrURL,
}

abstract class BaseProposalDefinition {
  final DefinitionsObjectTypes type;
  final String note;

  const BaseProposalDefinition({
    required this.type,
    required this.note,
  });
}

class ProposalDefinitions {
  final SegmentProposalDefinition segmentDefinition;
  final SectionProposalDefinition sectionDefinition;
  final SingleLineTextEntryDefinition singleLineTextEntryDefinition;

  const ProposalDefinitions({
    required this.segmentDefinition,
    required this.sectionDefinition,
    required this.singleLineTextEntryDefinition,
  });

  BaseProposalDefinition getDefinition(String refPath) {
    final ref = refPath.split('/').last;
    return switch (ref) {
      'segment' => segmentDefinition,
      'section' => sectionDefinition,
      'singleLineTextEntry' => singleLineTextEntryDefinition,
      _ => UnknownProposalDefinition(
          type: DefinitionsObjectTypes.fromString(ref.split('/').last),
          note: 'Unknown definition',
        ),
    };
  }
}

class SegmentProposalDefinition extends BaseProposalDefinition {
  final bool additionalProperties;

  const SegmentProposalDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });
}

class SectionProposalDefinition extends BaseProposalDefinition {
  final bool additionalProperties;

  const SectionProposalDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });
}

class SingleLineTextEntryDefinition extends BaseProposalDefinition {
  final DefinitionsContentMediaType contentMediaType;
  final String pattern;

  const SingleLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });
}

class UnknownProposalDefinition extends BaseProposalDefinition {
  const UnknownProposalDefinition({
    required super.type,
    required super.note,
  });
}
