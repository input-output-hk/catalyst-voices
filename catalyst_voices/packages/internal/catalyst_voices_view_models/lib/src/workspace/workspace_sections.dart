import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

part 'capability_and_feasibility.dart';
part 'proposal_impact.dart';
part 'proposal_setup.dart';
part 'proposal_solution.dart';
part 'proposal_summary.dart';

sealed class WorkspaceSection extends BaseSection<WorkspaceSectionStep> {
  const WorkspaceSection({
    required super.id,
    required super.steps,
  });
}

sealed class WorkspaceSectionStep extends BaseSectionStep {
  const WorkspaceSectionStep({
    required super.id,
    super.isEnabled,
    super.isEditable,
  });
}

abstract base class RichTextStep extends WorkspaceSectionStep {
  final DocumentJson data;
  final int? charsLimit;

  const RichTextStep({
    required super.id,
    required this.data,
    this.charsLimit,
    super.isEditable,
  });

  String localizedDesc(BuildContext context) => localizedName(context);
}
