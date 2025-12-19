import 'dart:async';

import 'package:catalyst_voices/pages/proposal/widget/proposal_invitation_dialog.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalInvitationBanner extends StatelessWidget {
  const ProposalInvitationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, CollaboratorInvitationState>(
      selector: (state) => state.invitation,
      builder: (context, invitation) {
        return switch (invitation) {
          PendingCollaboratorInvitationState() => const _InvitationPendingBanner(),
          AcceptedCollaboratorInvitationState() => const _InvitationAcceptedBanner(),
          RejectedCollaboratorInvitationState() => const _InvitationRejectedBanner(),
          NoneCollaboratorInvitationState() => const Offstage(),
        };
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
        child: Text(context.l10n.proposalViewPendingInvitationBannerAcceptButton),
        onTap: () => _showDialog(context),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final accepted = await ProposalAcceptInvitationDialog.show(context) ?? false;

    if (accepted && context.mounted) {
      unawaited(context.read<ProposalCubit>().acceptInvitation());
    }
  }
}

class _ChangeToAllowButton extends StatelessWidget {
  const _ChangeToAllowButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(context.l10n.proposalViewRejectedInvitationBannerChangeToAllow),
      onTap: () => _acceptInvitation(context),
    );
  }

  void _acceptInvitation(BuildContext context) {
    unawaited(context.read<ProposalCubit>().acceptInvitation());
  }
}

class _ChangeToDenyButton extends StatelessWidget {
  const _ChangeToDenyButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(context.l10n.proposalViewAcceptedInvitationBannerChangeToDeny),
      onTap: () => _rejectInvitation(context),
    );
  }

  void _rejectInvitation(BuildContext context) {
    unawaited(context.read<ProposalCubit>().rejectInvitation());
  }
}

class _InvitationAcceptedBanner extends StatelessWidget {
  const _InvitationAcceptedBanner();

  @override
  Widget build(BuildContext context) {
    return _InvitationDismissibleBanner(
      icon: VoicesAssets.icons.check.buildIcon(color: Theme.of(context).colors.iconsSuccess),
      message: context.l10n.proposalViewAcceptedInvitationBannerMessage,
      button: const _ChangeToDenyButton(),
    );
  }
}

class _InvitationDismissibleBanner extends StatelessWidget {
  final Widget icon;
  final String message;
  final Widget button;

  const _InvitationDismissibleBanner({
    required this.icon,
    required this.message,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        border: Border(bottom: BorderSide(color: Theme.of(context).colors.outlineBorder)),
      ),
      child: AffixDecorator(
        // Reserve space for the 'x' button to have symmetry.
        prefix: const SizedBox.square(dimension: 28),
        suffix: VoicesIconButton(
          child: VoicesAssets.icons.x.buildIcon(
            size: 28,
            color: Theme.of(context).colors.iconsPrimary,
          ),
          onTap: () => context.read<ProposalCubit>().dismissInvitation(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconTheme.of(context).copyWith(size: 28),
              child: icon,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: MarkdownText(
                MarkdownData(message),
                pStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 16),
            button,
          ],
        ),
      ),
    );
  }
}

class _InvitationPendingBanner extends StatelessWidget {
  const _InvitationPendingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        border: Border(bottom: BorderSide(color: Theme.of(context).colors.outlineBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VoicesAssets.icons.userGroup.buildIcon(
            size: 28,
            color: Theme.of(context).colors.iconsPrimary,
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              context.l10n.proposalViewPendingInvitationBannerMessage,
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

class _InvitationRejectedBanner extends StatelessWidget {
  const _InvitationRejectedBanner();

  @override
  Widget build(BuildContext context) {
    return _InvitationDismissibleBanner(
      icon: VoicesAssets.icons.xCircle.buildIcon(color: Theme.of(context).colors.iconsError),
      message: context.l10n.proposalViewRejectedInvitationBannerMessage,
      button: const _ChangeToAllowButton(),
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
        child: Text(context.l10n.proposalViewPendingInvitationBannerRejectButton),
        onTap: () => _showDialog(context),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final rejected = await ProposalRejectInvitationDialog.show(context) ?? false;

    if (rejected && context.mounted) {
      unawaited(context.read<ProposalCubit>().rejectInvitation());
    }
  }
}
