part of 'workspace_sections.dart';

final class ProposalImpact extends WorkspaceSection {
  const ProposalImpact({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Proposal impact';
  }
}

final class BonusMarkUpStep extends RichTextStep {
  const BonusMarkUpStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Bonus mark-up';
  }
}

final class ValueForMoneyStep extends RichTextStep {
  const ValueForMoneyStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Value for Money';
  }
}
