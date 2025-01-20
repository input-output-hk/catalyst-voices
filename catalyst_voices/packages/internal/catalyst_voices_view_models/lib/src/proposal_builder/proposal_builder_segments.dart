import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class ProposalBuilderSegment extends BaseSegment<ProposalBuilderSection> {
  final DocumentObjectProperty documentSegment;

  const ProposalBuilderSegment({
    required super.id,
    required super.sections,
    required this.documentSegment,
  });

  @override
  String resolveTitle(BuildContext context) {
    return documentSegment.schema.title;
  }
}

final class ProposalBuilderSection extends BaseSection {
  final DocumentObjectProperty documentSection;

  const ProposalBuilderSection({
    required super.id,
    required this.documentSection,
    super.isEnabled,
    super.isEditable,
  });

  @override
  String resolveTitle(BuildContext context) {
    return documentSection.schema.title;
  }
}
