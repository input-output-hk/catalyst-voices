enum DefinitionsObjectType {
  string,
  object,
  integer,
  boolean,
  array,
  unknown;

  const DefinitionsObjectType();

  static DefinitionsObjectType fromString(String value) {
    return DefinitionsObjectType.values.asNameMap()[value] ??
        DefinitionsObjectType.unknown;
  }

  dynamic get getDefaultValue => switch (this) {
        string => '',
        integer => 0,
        boolean => true,
        array => <String>[],
        object => <String, dynamic>{},
        unknown => 'unknown',
      };
}

enum DefinitionsContentMediaType {
  textPlain('text/plain'),
  markdown('text/markdown'),
  unknown('unknown');

  final String value;

  const DefinitionsContentMediaType(this.value);

  static DefinitionsContentMediaType fromString(String value) {
    return DefinitionsContentMediaType.values.asNameMap()[value] ??
        DefinitionsContentMediaType.unknown;
  }
}

enum DefinitionsFormat {
  path,
  uri,
  dropDownSingleSelect,
  multiSelect,
  singleLineTextEntryList,
  singleLineTextEntryListMarkdown,
  singleLineHttpsURLEntryList,
  nestedQuestionsList,
  nestedQuestions,
  singleGroupedTagSelector,
  tagGroup,
  tagSelection,
  tokenValueCardanoADA,
  datetimeDurationMonths,
  yesNoChoice,
  agreementConfirmation,
  spdxLicenseOrURL,
  unknown;

  const DefinitionsFormat();

  static DefinitionsFormat fromString(String value) {
    return DefinitionsFormat.values.firstWhere(
      (type) => type.name == value,
      orElse: () => DefinitionsFormat.unknown,
    );
  }
}

enum DefinitionsType {
  section,
  segment,
  singleLineTextEntry,
  // singleLineHttpsURLEntry,

  // multiLineTextEntry;
  durationInMonths;

  const DefinitionsType();

  static DefinitionsType fromString(String value) {
    return DefinitionsType.values.byName(value);
  }

  Object get definitionType => switch (this) {
        section => SectionDefinition,
        segment => SegmentDefinition,
        singleLineTextEntry => SingleLineTextEntryDefinition,
        durationInMonths => DurationInMonthsDefinition,
      };
}

abstract class BaseDefinition {
  final DefinitionsObjectType type;
  final String note;

  const BaseDefinition({
    required this.type,
    required this.note,
  });
}

extension BaseDefinitionListExt on List<BaseDefinition> {
  BaseDefinition getDefinition(String refPath) {
    final ref = refPath.split('/').last;
    final enum2 = DefinitionsType.fromString(ref);
    final obj = enum2.definitionType;

    return firstWhere((e) => e.runtimeType == obj);
  }
}

class SegmentDefinition extends BaseDefinition {
  final bool additionalProperties;

  const SegmentDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });
}

class SectionDefinition extends BaseDefinition {
  final bool additionalProperties;

  const SectionDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });
}

class SingleLineTextEntryDefinition extends BaseDefinition {
  final DefinitionsContentMediaType contentMediaType;
  final String pattern;

  const SingleLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });
}

class DurationInMonthsDefinition extends BaseDefinition {
  final DefinitionsFormat format;

  const DurationInMonthsDefinition({
    required super.type,
    required super.note,
    required this.format,
  });
}
