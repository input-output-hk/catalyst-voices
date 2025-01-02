import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum DocumentDefinitionsObjectType {
  string,
  object,
  integer,
  boolean,
  array,
  unknown;

  static DocumentDefinitionsObjectType fromString(String value) {
    return DocumentDefinitionsObjectType.values.asNameMap()[value] ??
        DocumentDefinitionsObjectType.unknown;
  }

  dynamic get defaultValue => switch (this) {
        string => '',
        integer => 0,
        boolean => true,
        array => <String>[],
        object => <String, dynamic>{},
        unknown => 'unknown',
      };
}

enum DocumentDefinitionsContentMediaType {
  textPlain('text/plain'),
  markdown('text/markdown'),
  unknown('unknown');

  final String schemaValue;

  const DocumentDefinitionsContentMediaType(this.schemaValue);

  static DocumentDefinitionsContentMediaType fromString(String value) {
    return DocumentDefinitionsContentMediaType.values
            .firstWhereOrNull((e) => e.schemaValue.toLowerCase() == value) ??
        DocumentDefinitionsContentMediaType.unknown;
  }
}

enum DocumentDefinitionsFormat {
  path('path'),
  uri('uri'),
  dropDownSingleSelect('dropDownSingleSelect'),
  multiSelect('multiSelect'),
  singleLineTextEntryList('singleLineTextEntryList'),
  singleLineTextEntryListMarkdown('singleLineTextEntryListMarkdown'),
  singleLineHttpsURLEntryList('singleLineHttpsURLEntryList'),
  nestedQuestionsList('nestedQuestionsList'),
  nestedQuestions('nestedQuestions'),
  singleGroupedTagSelector('singleGroupedTagSelector'),
  tagGroup('tagGroup'),
  tagSelection('tagSelection'),
  tokenCardanoADA('token:cardano:ada'),
  durationInMonths('datetime:duration:months'),
  yesNoChoice('yesNoChoice'),
  agreementConfirmation('agreementConfirmation'),
  spdxLicenseOrURL('spdxLicenseOrURL'),
  unknown('unknown');

  final String value;

  const DocumentDefinitionsFormat(this.value);

  static DocumentDefinitionsFormat fromString(String value) {
    return DocumentDefinitionsFormat.values
            .firstWhereOrNull((e) => e.value.toLowerCase() == value) ??
        DocumentDefinitionsFormat.unknown;
  }
}

sealed class BaseDocumentDefinition<T extends Object> extends Equatable {
  final DocumentDefinitionsObjectType type;
  final String note;

  const BaseDocumentDefinition({
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

  T? castValue(Object? value);

  DocumentProperty<T> castProperty(DocumentProperty<T> property);
}

extension BaseDocumentDefinitionListExt on List<BaseDocumentDefinition> {
  BaseDocumentDefinition getDefinition(String refPath) {
    final definitionType = BaseDocumentDefinition.typeFromRefPath(refPath);
    final classType = definitionType;

    return firstWhere((e) => e.runtimeType == classType);
  }
}

final class SegmentDefinition extends BaseDocumentDefinition {
  final bool additionalProperties;

  const SegmentDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });

  @override
  List<Object?> get props => [
        type,
        note,
        additionalProperties,
      ];

  @override
  DocumentProperty<Object> castProperty(DocumentProperty<Object> property) {
    return property;
  }

  @override
  Object? castValue(Object? value) {
    return value;
  }
}

final class SectionDefinition extends BaseDocumentDefinition {
  final bool additionalProperties;

  const SectionDefinition({
    required super.type,
    required super.note,
    required this.additionalProperties,
  });

  @override
  List<Object?> get props => [
        additionalProperties,
        type,
        note,
      ];

  @override
  DocumentProperty<Object> castProperty(DocumentProperty<Object> property) {
    return property;
  }

  @override
  Object? castValue(Object? value) {
    return value;
  }
}

final class SingleLineTextEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const SingleLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class SingleLineHttpsURLEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const SingleLineHttpsURLEntryDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class MultiLineTextEntryDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class MultiLineTextEntryMarkdownDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const MultiLineTextEntryMarkdownDefinition({
    required super.type,
    required super.note,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        contentMediaType,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class DropDownSingleSelectDefinition
    extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final DocumentDefinitionsContentMediaType contentMediaType;
  final String pattern;

  const DropDownSingleSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.contentMediaType,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        format,
        contentMediaType,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class MultiSelectDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;

  const MultiSelectDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
  });

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
      ];

  @override
  DocumentProperty<List<dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<List<dynamic>>;
  }

  @override
  List<dynamic>? castValue(Object? value) {
    return value as List<dynamic>?;
  }
}

final class SingleLineTextEntryListDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<dynamic> defaultValues;
  final Map<String, dynamic> items;

  const SingleLineTextEntryListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValues,
    required this.items,
  });

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValues,
        items,
      ];

  @override
  DocumentProperty<List<dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<List<dynamic>>;
  }

  @override
  List<dynamic>? castValue(Object? value) {
    return value as List<dynamic>?;
  }
}

final class MultiLineTextEntryListMarkdownDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
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

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
        items,
      ];

  @override
  DocumentProperty<List<dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<List<dynamic>>;
  }

  @override
  List<dynamic>? castValue(Object? value) {
    return value as List<dynamic>?;
  }
}

final class SingleLineHttpsURLEntryListDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
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

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
        items,
      ];

  @override
  DocumentProperty<List<dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<List<dynamic>>;
  }

  @override
  List<dynamic>? castValue(Object? value) {
    return value as List<dynamic>?;
  }
}

final class NestedQuestionsListDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool uniqueItems;
  final List<dynamic> defaultValue;

  const NestedQuestionsListDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.uniqueItems,
    required this.defaultValue,
  });

  @override
  List<Object?> get props => [
        format,
        uniqueItems,
        type,
        note,
        defaultValue,
      ];

  @override
  DocumentProperty<List<dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<List<dynamic>>;
  }

  @override
  List<dynamic>? castValue(Object? value) {
    return value as List<dynamic>?;
  }
}

// TODO(ryszard-schossler): Verify BaseDocumentDefinition type
final class NestedQuestionsDefinition
    extends BaseDocumentDefinition<List<dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool additionalProperties;

  const NestedQuestionsDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];

  @override
  DocumentProperty<List<dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<List<dynamic>>;
  }

  @override
  List<dynamic>? castValue(Object? value) {
    return value as List<dynamic>?;
  }
}

// TODO(ryszard-schossler): Verify BaseDocumentDefinition type
final class SingleGroupedTagSelectorDefinition
    extends BaseDocumentDefinition<Map<String, dynamic>> {
  final DocumentDefinitionsFormat format;
  final bool additionalProperties;

  const SingleGroupedTagSelectorDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.additionalProperties,
  });

  @override
  List<Object?> get props => [
        format,
        additionalProperties,
        type,
        note,
      ];

  @override
  DocumentProperty<Map<String, dynamic>> castProperty(
    DocumentProperty<Object> property,
  ) {
    return property as DocumentProperty<Map<String, dynamic>>;
  }

  @override
  Map<String, dynamic>? castValue(Object? value) {
    return value as Map<String, dynamic>?;
  }
}

final class TagGroupDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const TagGroupDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class TagSelectionDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;

  const TagSelectionDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
  });

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}

final class TokenValueCardanoADADefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const TokenValueCardanoADADefinition({
    required super.type,
    required super.note,
    required this.format,
  });

  @override
  List<Object?> get props => [
        format,
        type,
        note,
      ];

  @override
  DocumentProperty<int> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<int>;
  }

  @override
  int? castValue(Object? value) {
    return value as int?;
  }
}

final class DurationInMonthsDefinition extends BaseDocumentDefinition<int> {
  final DocumentDefinitionsFormat format;

  const DurationInMonthsDefinition({
    required super.type,
    required super.note,
    required this.format,
  });

  @override
  List<Object?> get props => [
        type,
        note,
        format,
      ];

  @override
  DocumentProperty<int> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<int>;
  }

  @override
  int? castValue(Object? value) {
    return value as int?;
  }
}

final class YesNoChoiceDefinition extends BaseDocumentDefinition<bool> {
  final DocumentDefinitionsFormat format;
  final bool defaultValue;

  const YesNoChoiceDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
  });

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        type,
        note,
      ];

  @override
  DocumentProperty<bool> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<bool>;
  }

  @override
  bool? castValue(Object? value) {
    return value as bool?;
  }
}

final class AgreementConfirmationDefinition
    extends BaseDocumentDefinition<bool> {
  final DocumentDefinitionsFormat format;
  final bool defaultValue;
  final bool constValue;

  const AgreementConfirmationDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.defaultValue,
    required this.constValue,
  });

  @override
  List<Object?> get props => [
        format,
        defaultValue,
        constValue,
        type,
        note,
      ];

  @override
  DocumentProperty<bool> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<bool>;
  }

  @override
  bool? castValue(Object? value) {
    return value as bool?;
  }
}

final class SPDXLicenceOrUrlDefinition extends BaseDocumentDefinition<String> {
  final DocumentDefinitionsFormat format;
  final String pattern;
  final DocumentDefinitionsContentMediaType contentMediaType;

  const SPDXLicenceOrUrlDefinition({
    required super.type,
    required super.note,
    required this.format,
    required this.pattern,
    required this.contentMediaType,
  });

  @override
  List<Object?> get props => [
        format,
        pattern,
        type,
        note,
      ];

  @override
  DocumentProperty<String> castProperty(DocumentProperty<Object> property) {
    return property as DocumentProperty<String>;
  }

  @override
  String? castValue(Object? value) {
    return value as String?;
  }
}
