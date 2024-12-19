part of 'workspace_sections.dart';

final class ProposalSummary extends WorkspaceSection {
  const ProposalSummary({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Proposal summary';
  }
}

final class ProblemStep extends RichTextStep {
  const ProblemStep({
    required super.id,
    required super.sectionId,
    required super.data,
    super.charsLimit,
    super.guidances,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Problem segment';
  }
}

final class SolutionStep extends RichTextStep {
  const SolutionStep({
    required super.id,
    required super.sectionId,
    required super.data,
    super.charsLimit,
    super.guidances,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Solution segment';
  }
}

final class PublicDescriptionStep extends RichTextStep {
  const PublicDescriptionStep({
    required super.id,
    required super.sectionId,
    required super.data,
    super.charsLimit,
    super.guidances,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Public description';
  }
}
