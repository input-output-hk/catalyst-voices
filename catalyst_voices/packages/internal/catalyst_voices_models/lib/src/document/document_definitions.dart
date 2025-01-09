library catalysts_voices_models;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'definitions/agreement_confirmation_definition.dart';
part 'definitions/drop_down_single_select_definition.dart';
part 'definitions/duration_in_months_definition.dart';
part 'definitions/language_code_definition.dart';
part 'definitions/multi_line_text_entry_definition.dart';
part 'definitions/multi_line_text_entry_list_markdown_definition.dart';
part 'definitions/multi_line_text_entry_markdown_definition.dart';
part 'definitions/multi_select_definition.dart';
part 'definitions/nested_questions_definition.dart';
part 'definitions/nested_questions_list_definition.dart';
part 'definitions/section_definition.dart';
part 'definitions/segment_definition.dart';
part 'definitions/single_grouped_tag_selector_definition.dart';
part 'definitions/single_line_https_url_entry_definition.dart';
part 'definitions/single_line_https_url_entry_list_definition.dart';
part 'definitions/single_line_text_entry_definition.dart';
part 'definitions/single_line_text_entry_list_definition.dart';
part 'definitions/spdx_license_or_url_definition.dart';
part 'definitions/tag_group_definition.dart';
part 'definitions/tag_selection_definition.dart';
part 'definitions/token_value_cardano_ada_definition.dart';
part 'definitions/yes_no_choice_definition.dart';

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

  /// Creates an instance of [DocumentSchemaProperty]
  /// of the same type [T] as this definition has.
  ///
  /// This is needed when processing schemas
  /// in bulk and when the type T is not known.
  DocumentSchemaProperty<T> createSchema({
    required DocumentNodeId nodeId,
    required String id,
    required String? title,
    required String? description,
    required T? defaultValue,
    required String? guidance,
    required List<String>? enumValues,
    required Range<int>? numRange,
    required Range<int>? strLengthRange,
    required Range<int>? itemsRange,
    required List<DocumentSchemaLogicalGroup>? oneOf,
    required bool isRequired,
  }) {
    return DocumentSchemaProperty(
      definition: this,
      nodeId: nodeId,
      id: id,
      title: title,
      description: description,
      defaultValue: defaultValue,
      guidance: guidance,
      enumValues: enumValues,
      numRange: numRange,
      strLengthRange: strLengthRange,
      itemsRange: itemsRange,
      oneOf: oneOf,
      isRequired: isRequired,
    );
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

  /// Validates the property [value] against document rules.
  DocumentValidationResult validatePropertyValue(
    DocumentSchemaProperty<T> schema,
    T? value,
  );
}

extension BaseDocumentDefinitionListExt on List<BaseDocumentDefinition> {
  BaseDocumentDefinition getDefinition(String refPath) {
    final definitionType = BaseDocumentDefinition.typeFromRefPath(refPath);
    final classType = definitionType;

    return firstWhere((e) => e.runtimeType == classType);
  }
}
