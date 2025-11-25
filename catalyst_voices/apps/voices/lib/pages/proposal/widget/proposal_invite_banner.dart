import 'dart:async';

import 'package:catalyst_voices/pages/proposal/widget/proposal_invitation_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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

class _AcceptButton extends StatelessWidget {
  const _AcceptButton();

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.filled(
        style: style,
        child: VoicesAssets.icons.check.buildIcon(),
        onTap: () => _showDialog(context),
      ),
      sm: (context) => VoicesFilledButton(
        style: style,
        child: Text(context.l10n.proposalViewInvitationBannerAcceptButton),
        onTap: () => _showDialog(context),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    unawaited(ProposalAcceptInvitationDialog.show(context));
  }
}

class _ProposalInvitationBanner extends StatelessWidget {
  const _ProposalInvitationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VoicesAssets.icons.userGroup.buildIcon(size: 28),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              context.l10n.proposalViewInvitationBannerMessage,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 20),
          const _AcceptButton(),
          const SizedBox(width: 8),
          const _RejectButton(),
        ],
      ),
    );
  }
}

class _RejectButton extends StatelessWidget {
  const _RejectButton();

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.outlined(
        style: style,
        child: VoicesAssets.icons.x.buildIcon(),
        onTap: () => _showDialog(context),
      ),
      sm: (context) => VoicesOutlinedButton(
        style: style,
        child: Text(context.l10n.proposalViewInvitationBannerRejectButton),
        onTap: () => _showDialog(context),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    unawaited(ProposalRejectInvitationDialog.show(context));
  }
}
