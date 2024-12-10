import 'package:catalyst_voices_models/src/proposal_template/definitions/definition.dart';

sealed class TextEntryDefinition extends Definition {
  const TextEntryDefinition({
    required String super.contentMediaType,
    required String super.pattern,
    required super.type,
  });
}

final class SingleLineTextEntryDefinition extends TextEntryDefinition {
  const SingleLineTextEntryDefinition()
      : super(
          contentMediaType: 'text/plain',
          pattern: r'^.*$',
          type: 'string',
        );
}

final class SingleLineHttpsURLEntryDefinition extends TextEntryDefinition {
  const SingleLineHttpsURLEntryDefinition()
      : super(
          contentMediaType: 'text/plain',
          pattern: '^https:.*',
          type: 'string',
        );
}

final class MultiLineTextEntryDefinition extends TextEntryDefinition {
  const MultiLineTextEntryDefinition()
      : super(
          contentMediaType: 'text/plain',
          pattern: r'^[\S\s]*$',
          type: 'string',
        );
}

final class MultiLineTextEntryMarkdownDefinition extends TextEntryDefinition {
  const MultiLineTextEntryMarkdownDefinition()
      : super(
          contentMediaType: 'text/markdown',
          pattern: r'^[\S\s]*$',
          type: 'string',
        );
}
