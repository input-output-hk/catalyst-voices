import 'package:catalyst_voices/pages/proposal/widget/proposal_invitation_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalInvitationBanner extends StatelessWidget {
  const ProposalInvitationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, bool>(
      selector: (state) => state.showInvitation,
      builder: (context, showCollaboratorInvitation) {
        return Offstage(
          offstage: !showCollaboratorInvitation,
          child: const _ProposalInvitationBanner(),
        );
      },
    );
  }
}

class _ProposalInvitationBanner extends StatelessWidget {
  const _ProposalInvitationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      child: Row(
        children: [
          VoicesAssets.icons.userGroup.buildIcon(size: 28),
          const SizedBox(width: 20),
          Text(context.l10n.proposalViewInvitationBannerMessage),
          const SizedBox(width: 20),
          VoicesFilledButton(
            child: Text(context.l10n.proposalViewInvitationBannerAcceptButton),
            onTap: () => ProposalAcceptInvitationDialog.show(context),
          ),
          const SizedBox(width: 8),
          VoicesOutlinedButton(
            child: Text(context.l10n.proposalViewInvitationBannerRejectButton),
            onTap: () => ProposalRejectInvitationDialog.show(context),
          ),
        ],
      ),
    );
  }
}
