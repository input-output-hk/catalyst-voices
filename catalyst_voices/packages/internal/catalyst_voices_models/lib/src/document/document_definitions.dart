import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'document_definitions_list.dart';

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
    'languageCode': LanguageCodeDefinition,
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

  /// Casts a dynamic value from external JSON to type [T].
  ///
  /// Since JSON data types are dynamic, this method uses known
  /// definition types to cast values to [T] for easier usage in UI widgets.
  ///
  /// Returns the value as type [T] if successful, or `null` otherwise.
  T? castValue(Object? value) {
    return value as T?;
  }

  /// Casts a [DocumentProperty<Object>] to [DocumentProperty<T>].
  ///
  /// This method sets a specific type [T] for a [DocumentProperty],
  /// which holds a user-provided answer in the frontend.
  ///
  /// [property] is the [DocumentProperty<Object>] to be cast.
  ///
  /// Returns a [DocumentProperty] with its value cast to type [T].
  DocumentProperty<T> castProperty(DocumentProperty<Object> property) {
    if (property.schema.definition != this) {
      throw ArgumentError(
        'The ${property.schema.nodeId} cannot be cast '
        'by $this document definition',
      );
    }
    return property as DocumentProperty<T>;
  }

  /// Validates the [property] against document rules.
  DocumentValidationResult validateProperty(DocumentProperty<T> property);
}

extension BaseDocumentDefinitionListExt on List<BaseDocumentDefinition> {
  BaseDocumentDefinition getDefinition(String refPath) {
    final definitionType = BaseDocumentDefinition.typeFromRefPath(refPath);
    final classType = definitionType;

    return firstWhere((e) => e.runtimeType == classType);
  }
}
