import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_share_dialog.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ShareProposalDialog extends StatelessWidget {
  final String shareUrl;

  const ShareProposalDialog({
    super.key,
    required this.shareUrl,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesShareDialog(
      key: const Key('ShareProposalDialog'),
      shareItemType: context.l10n.proposal,
      shareUrl: shareUrl,
      shareMessage: context.l10n.proposalShareMessage,
    );
  }

  static Future<void> show(BuildContext context, String shareUrl) async {
    final result = VoicesDialog.show<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/share-proposal'),
      builder: (context) => ShareProposalDialog(
        shareUrl: shareUrl,
      ),
    );

    return result;
  }
}
