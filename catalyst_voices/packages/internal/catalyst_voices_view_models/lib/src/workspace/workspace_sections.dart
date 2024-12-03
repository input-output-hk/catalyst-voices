import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class WorkspaceSection extends BaseSection<WorkspaceSectionStep> {
  final String name;

  const WorkspaceSection({
    required super.id,
    required super.steps,
    required this.name,
  });

  @override
  String localizedName(BuildContext context) => name;
}

sealed class WorkspaceSectionStep extends BaseSectionStep {
  const WorkspaceSectionStep({
    required super.id,
    required super.sectionId,
    super.isEnabled,
    super.isEditable,
  });
}

final class RichTextStep extends WorkspaceSectionStep {
  final String name;
  final String? description;
  final DocumentJson initialData;
  final int? charsLimit;

  const RichTextStep({
    required super.id,
    required super.sectionId,
    required this.name,
    this.description,
    this.initialData = const DocumentJson([]),
    this.charsLimit,
    super.isEditable,
  });

  @override
  String localizedName(BuildContext context) => name;
}
