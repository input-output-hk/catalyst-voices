import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBuilderBackAction extends StatelessWidget {
  const ProposalBuilderBackAction({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () => const WorkspaceRoute().go(context),
      leading: VoicesAssets.icons.logout.buildIcon(),
      child: Text(context.l10n.proposalEditorBackToProposals),
    );
  }
}
