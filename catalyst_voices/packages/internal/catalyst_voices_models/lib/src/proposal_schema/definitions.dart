import 'package:meta/meta.dart';

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
    return DefinitionsFormat.values.asNameMap()[value] ??
        DefinitionsFormat.unknown;
  }
}

// enum DefinitionsType {
//   segment,
//   section,
//   singleLineTextEntry,
//   multiLineTextEntry,
//   multiLineTextEntryMarkdown,
//   dropDownSingleSelect,
//   multiSelect,
//   singleLineTextEntryList,
//   multiLineTextEntryListMarkdown,
//   singleLineHttpsURLEntry,
//   singleLineHttpsURLEntryList,
//   nestedQuestionsList,
//   nestedQuestions,
//   singleGroupedTagSelector,
//   tagGroup,
//   tagSelection,
//   tokenValueCardanoADA,
//   durationInMonths,
//   yesNoChoice,
//   agreementConfirmation,
//   spdxLicenseOrURL;

//   const DefinitionsType();

//   static DefinitionsType fromString(String value) {
//     return values.byName(value);
//   }

//   static bool isKnownType(String refPath) {
//     final ref = refPath.split('/').last;
//     return values.asNameMap()[ref] != null;
//   }

//   Object get definitionType => switch (this) {
//         section => SectionDefinition,
//         segment => SegmentDefinition,
//         singleLineTextEntry => SingleLineTextEntryDefinition,
//         durationInMonths => DurationInMonthsDefinition,
//         singleLineHttpsURLEntry => SingleLineHttpsURLEntryDefinition,
//         multiLineTextEntry => MultiLineTextEntryDefinition,
//         multiLineTextEntryMarkdown => MultiLineTextEntryMarkdownDefinition,
//         dropDownSingleSelect => DropDownSingleSelectDefinition,
//         multiSelect => MultiSelectDefinition,
//         singleLineTextEntryList => SingleLineTextEntryListDefinition,
//         multiLineTextEntryListMarkdown =>
//           MultiLineTextEntryListMarkdownDefinition,
//         singleLineHttpsURLEntryList => SingleLineHttpsURLEntryListDefinition,
//         nestedQuestionsList => NestedQuestionsListDefinition,
//         nestedQuestions => NestedQuestionsDefinition,
//         singleGroupedTagSelector => SingleGroupedTagSelectorDefinition,
//         tagGroup => TagGroupDefinition,
//         tagSelection => TagSelectionDefinition,
//         tokenValueCardanoADA => TokenValueCardanoADADefinition,
//         yesNoChoice => YesNoChoiceDefinition,
//         agreementConfirmation => AgreementConfirmationDefinition,
//         spdxLicenseOrURL => SPDXLicenceOrUrlDefinition,
//       };
// }

sealed class BaseDefinition {
  final DefinitionsObjectType type;
  final String note;

  const BaseDefinition({
    required this.type,
    required this.note,
  });
  @visibleForTesting
  static final Map<String, Type> refPathToDefinitionType = {
    'segment': SegmentDefinition,
    'section': SectionDefinition,
    'singleLineTextEntry': SingleLineTextEntryDefinition,
    'singleLineHttpsURLEntry': SingleLineHttpsURLEntryDefinition,
    'multiLineTextEntry': MultiLineTextEntryDefinition,
    'multiLineTextEntryMarkdown': MultiLineTextEntryMarkdownDefinition,
    'dropDownSingleSelect': DropDownSingleSelectDefinition,
    'multiSelect': MultiSelectDefinition,
    'singleLineTextEntryList': SingleLineTextEntryListDefinition,
    'multiLineTextEntryListMarkdown': MultiLineTextEntryListMarkdownDefinition,
    'singleLineHttpsURLEntryList': SingleLineHttpsURLEntryListDefinition,
    'nestedQuestionsList': NestedQuestionsListDefinition,
    'nestedQuestions': NestedQuestionsDefinition,
    'singleGroupedTagSelector': SingleGroupedTagSelectorDefinition,
    'tagGroup': TagGroupDefinition,
    'tagSelection': TagSelectionDefinition,
    'tokenValueCardanoADA': TokenValueCardanoADADefinition,
    'durationInMonths': DurationInMonthsDefinition,
    'yesNoChoice': YesNoChoiceDefinition,
    'agreementConfirmation': AgreementConfirmationDefinition,
    'spdxLicenseOrURL': SPDXLicenceOrUrlDefinition,
  };

  static Type typeFromRefPath(String refPath) {
    final ref = refPath.split('/').last;
    return refPathToDefinitionType[ref] ??
        (throw ArgumentError('Unknown refPath: $refPath'));
  }

  static bool isKnownType(String refPath) {
    final ref = refPath.split('/').last;
    return refPathToDefinitionType[ref] != null;
  }
}

extension BaseDefinitionListExt on List<BaseDefinition> {
  BaseDefinition getDefinition(String refPath) {
    final definitionType = BaseDefinition.typeFromRefPath(refPath);
    final classType = definitionType;

    return firstWhere((e) => e.runtimeType == classType);
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

class SingleLineHttpsURLEntryDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final String pattern;

  const SingleLineHttpsURLEntryDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });
}

class MultiLineTextEntryDefinition extends BaseDefinition {
  final DefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });
}

class MultiLineTextEntryMarkdownDefinition extends BaseDefinition {
  final DefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryMarkdownDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });
}

class DropDownSingleSelectDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final DefinitionsContentMediaType contentMediaType;
  final String pattern;

  const DropDownSingleSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.contentMediaType,
    required this.pattern,
  });
}

class MultiSelectDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool uniqueItems;

  const MultiSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
  });
}

class SingleLineTextEntryListDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool uniqueItems;
  final List<String> defaultValues;
  final Map<String, dynamic> items;

  const SingleLineTextEntryListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValues,
    required this.items,
  });
}

class MultiLineTextEntryListMarkdownDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool uniqueItems;
  final List<dynamic> defaultValue;
  final Map<String, dynamic> items;

  const MultiLineTextEntryListMarkdownDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
  });
}

class SingleLineHttpsURLEntryListDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool uniqueItems;
  final List<dynamic> defaultValue;
  final Map<String, dynamic> items;

  const SingleLineHttpsURLEntryListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
    required this.items,
  });
}

class NestedQuestionsListDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool uniqueItems;
  final List<dynamic> defaultValue;

  const NestedQuestionsListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
  });
}

class NestedQuestionsDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool additionalProperties;
  const NestedQuestionsDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });
}

class SingleGroupedTagSelectorDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool additionalProperties;

  const SingleGroupedTagSelectorDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });
}

class TagGroupDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final String pattern;

  const TagGroupDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });
}

class TagSelectionDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final String pattern;

  const TagSelectionDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });
}

class TokenValueCardanoADADefinition extends BaseDefinition {
  final DefinitionsFormat format;

  const TokenValueCardanoADADefinition({
    required super.type,
    required super.note,
    required this.format,
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

class YesNoChoiceDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool defaultValue;

  const YesNoChoiceDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
  });
}

class AgreementConfirmationDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final bool defaultValue;
  final bool constValue;

  const AgreementConfirmationDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
    required this.constValue,
  });
}

class SPDXLicenceOrUrlDefinition extends BaseDefinition {
  final DefinitionsFormat format;
  final String pattern;
  final DefinitionsContentMediaType contentMediaType;

  const SPDXLicenceOrUrlDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
    required this.contentMediaType,
  });
}
