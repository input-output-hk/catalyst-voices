import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_share_dialog.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ShareProposalDialog extends StatelessWidget {
  final Uri uri;

  const ShareProposalDialog._({
    required this.uri,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: VoicesShareDialog(
          key: const Key('ShareProposalDialog'),
          shareItemType: context.l10n.proposal,
          data: ShareData(
            uri: uri,
            additionalMessage: context.l10n.proposalShareMessage,
          ),
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required DocumentRef ref,
  }) async {
    await VoicesDialog.show<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/share-proposal'),
      builder: (context) {
        final uri = ShareManager.of(context).resolveProposalUrl(ref: ref);
        return ShareProposalDialog._(uri: uri);
      },
    );
  }
}
