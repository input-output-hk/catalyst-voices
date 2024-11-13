part of 'workspace_sections.dart';

final class ProposalSetup extends WorkspaceSection {
  const ProposalSetup({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Proposal setup';
  }
}

final class TitleStep extends RichTextStep {
  const TitleStep({
    required super.id,
    required super.sectionId,
    required super.data,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Title';
  }
}
