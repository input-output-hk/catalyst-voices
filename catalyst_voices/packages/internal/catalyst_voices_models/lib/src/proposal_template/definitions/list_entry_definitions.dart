import 'package:catalyst_voices_models/src/proposal_template/definitions/definition.dart';

sealed class ListEntryDefinition extends Definition {
  final bool uniqueItems;
  final List<dynamic> defaultValue;

  ListEntryDefinition({
    this.uniqueItems = true,
    required this.defaultValue,
    super.type = 'array',
    super.format,
  });
}

final class SingleLineTextEntryListDefinition extends ListEntryDefinition {
  SingleLineTextEntryListDefinition({
    super.uniqueItems,
    required super.defaultValue,
    required super.type,
    super.format = 'singleLineTextEntryList',
  });
}

final class MultiLineTextEntryListMarkdownDefinition
    extends ListEntryDefinition {
  MultiLineTextEntryListMarkdownDefinition({
    super.uniqueItems,
    required super.defaultValue,
    super.format = 'multiLineTextEntryListMarkdown',
  });
}

final class SingleLineHttpsURLEntryListDefinition extends ListEntryDefinition {
  SingleLineHttpsURLEntryListDefinition({
    super.uniqueItems,
    required super.defaultValue,
    super.format = 'singleLineHttpsURLEntryList',
  });
}

final class NestedQuestionsListDefinition extends ListEntryDefinition {
  NestedQuestionsListDefinition({
    super.uniqueItems,
    required super.defaultValue,
    super.format = 'nestedQuestionsList',
  });
}

final class NestedQuestionsDefinition extends Definition {
  final bool additionalProperties;

  NestedQuestionsDefinition({
    this.additionalProperties = false,
    super.type = 'object',
    super.format = 'nestedQuestions',
  });
}
