import 'package:catalyst_voices_models/src/proposal_template/definitions/definition.dart';

sealed class LogicalSectionDefinition extends Definition {
  final bool additionalProperties;

  const LogicalSectionDefinition({
    required this.additionalProperties,
  }) : super(type: 'object');
}

final class SegmentDefinition extends LogicalSectionDefinition {
  const SegmentDefinition() : super(additionalProperties: false);
}

final class SectionDefinition extends LogicalSectionDefinition {
  const SectionDefinition() : super(additionalProperties: false);
}
