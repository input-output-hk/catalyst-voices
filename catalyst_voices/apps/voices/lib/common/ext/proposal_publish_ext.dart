import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension ProposalPublishExt on ProposalPublish {
  SvgGenImage get workspaceIcon => switch (this) {
        ProposalPublish.submittedProposal => VoicesAssets.icons.lockClosed,
        _ => VoicesAssets.icons.documentText,
      };

  String localizedWorkspaceName(VoicesLocalizations l10n) {
    return switch (this) {
      ProposalPublish.localDraft => l10n.notPublished,
      ProposalPublish.publishedDraft => l10n.draft,
      ProposalPublish.submittedProposal => l10n.finalProposal,
    };
  }
}
