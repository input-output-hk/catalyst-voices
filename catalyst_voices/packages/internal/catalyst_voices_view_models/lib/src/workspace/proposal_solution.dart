part of 'workspace_sections.dart';

final class ProposalSolution extends WorkspaceSection {
  const ProposalSolution({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Proposal solution';
  }
}

final class ProblemPerspectiveStep extends RichTextStep {
  const ProblemPerspectiveStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Problem perspective';
  }

  @override
  String localizedDesc(BuildContext context) {
    return "What is your perspective on the problem you're solving?";
  }
}

final class PerspectiveRationaleStep extends RichTextStep {
  const PerspectiveRationaleStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Perspective rationale';
  }

  @override
  String localizedDesc(BuildContext context) {
    return 'Why did you choose this perspective?';
  }
}

final class ProjectEngagementStep extends RichTextStep {
  const ProjectEngagementStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Project engagement';
  }

  @override
  String localizedDesc(BuildContext context) {
    return 'Who will your project engage?';
  }
}
