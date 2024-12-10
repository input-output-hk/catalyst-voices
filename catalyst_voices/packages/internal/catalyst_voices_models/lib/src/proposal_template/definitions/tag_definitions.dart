import 'package:catalyst_voices_models/src/proposal_template/definitions/definition.dart';

sealed class TagDefinition extends Definition {
  const TagDefinition({
    required super.type,
    required super.format,
    super.pattern,
  });
}

final class SingleGroupedTagSelectorDefinition extends TagDefinition {
  final bool additionalProperties;

  const SingleGroupedTagSelectorDefinition({
    this.additionalProperties = false,
  }) : super(
          type: 'object',
          format: 'singleGroupedTagSelector',
        );
}

final class TagGroupDefinition extends TagDefinition {
  const TagGroupDefinition()
      : super(
          type: 'string',
          format: 'tagGroup',
          pattern: r'^.*$',
        );
}

final class TagSelectionDefinition extends TagDefinition {
  const TagSelectionDefinition()
      : super(
          type: 'string',
          format: 'tagSelection',
          pattern: r'^.*$',
        );
}
