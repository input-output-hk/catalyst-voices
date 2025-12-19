import 'dart:async';

import 'package:catalyst_voices/pages/proposal/widget/proposal_collaborator_dialog.dart';
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

class ProposalCollaboratorBanner extends StatelessWidget {
  const ProposalCollaboratorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, CollaboratorProposalState>(
      selector: (state) => state.collaborator,
      builder: (context, state) {
        return switch (state) {
          PendingCollaboratorInvitationState() => const _PendingInvitationBanner(),
          AcceptedCollaboratorInvitationState() => const _AcceptedInvitationBanner(),
          RejectedCollaboratorInvitationState() => const _RejectedInvitationBanner(),
          PendingCollaboratorFinalProposalConsentState() => const _PendingFinalProposalBanner(),
          AcceptedFinalProposalConsentState() => const _AcceptedFinalProposalBanner(),
          RejectedCollaboratorFinalProposalConsentState() => const _RejectedFinalProposalBanner(),
          NoneCollaboratorProposalState() => const Offstage(),
        };
      },
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const _AcceptButton({
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.filled(
        style: style,
        onTap: onTap,
        child: VoicesAssets.icons.check.buildIcon(),
      ),
      sm: (context) => VoicesFilledButton(
        style: style,
        onTap: onTap,
        child: Text(message),
      ),
    );
  }
}

class _AcceptedFinalProposalBanner extends StatelessWidget {
  const _AcceptedFinalProposalBanner();

  @override
  Widget build(BuildContext context) {
    return _DismissibleBanner(
      icon: VoicesAssets.icons.check.buildIcon(color: Theme.of(context).colors.iconsSuccess),
      message: context.l10n.proposalViewAcceptedFinalProposalBannerMessage,
      button: const _ChangeToDenyFinalProposalButton(),
    );
  }
}

class _AcceptedInvitationBanner extends StatelessWidget {
  const _AcceptedInvitationBanner();

  @override
  Widget build(BuildContext context) {
    return _DismissibleBanner(
      icon: VoicesAssets.icons.check.buildIcon(color: Theme.of(context).colors.iconsSuccess),
      message: context.l10n.proposalViewAcceptedInvitationBannerMessage,
      button: const _ChangeToDenyInvitationButton(),
    );
  }
}

class _AcceptFinalProposalButton extends StatelessWidget {
  const _AcceptFinalProposalButton();

  @override
  Widget build(BuildContext context) {
    return _AcceptButton(
      message: context.l10n.approve,
      onTap: () => _showDialog(context),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final accepted = await ProposalAcceptFinalProposalDialog.show(context) ?? false;

    if (accepted && context.mounted) {
      unawaited(context.read<ProposalCubit>().acceptFinalProposal());
    }
  }
}

class _AcceptInvitationButton extends StatelessWidget {
  const _AcceptInvitationButton();

  @override
  Widget build(BuildContext context) {
    return _AcceptButton(
      message: context.l10n.proposalViewPendingInvitationBannerAcceptButton,
      onTap: () => _showDialog(context),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final accepted = await ProposalAcceptInvitationDialog.show(context) ?? false;

    if (accepted && context.mounted) {
      unawaited(context.read<ProposalCubit>().acceptCollaboratorInvitation());
    }
  }
}

class _ChangeToAllowFinalProposalButton extends StatelessWidget {
  const _ChangeToAllowFinalProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(context.l10n.proposalViewRejectedFinalProposalBannerChangeToApprove),
      onTap: () => _approveProposal(context),
    );
  }

  void _approveProposal(BuildContext context) {
    unawaited(context.read<ProposalCubit>().acceptFinalProposal());
  }
}

class _ChangeToAllowInvitationButton extends StatelessWidget {
  const _ChangeToAllowInvitationButton();

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
    unawaited(context.read<ProposalCubit>().acceptCollaboratorInvitation());
  }
}

class _ChangeToDenyFinalProposalButton extends StatelessWidget {
  const _ChangeToDenyFinalProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(context.l10n.proposalViewAcceptedFinalProposalBannerChangeToReject),
      onTap: () => _rejectProposal(context),
    );
  }

  void _rejectProposal(BuildContext context) {
    unawaited(context.read<ProposalCubit>().rejectFinalProposal());
  }
}

class _ChangeToDenyInvitationButton extends StatelessWidget {
  const _ChangeToDenyInvitationButton();

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
    unawaited(context.read<ProposalCubit>().rejectCollaboratorInvitation());
  }
}

class _DismissibleBanner extends StatelessWidget {
  final Widget icon;
  final String message;
  final Widget button;

  const _DismissibleBanner({
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
          onTap: () => context.read<ProposalCubit>().dismissCollaboratorBanner(),
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

class _PendingBanner extends StatelessWidget {
  final String message;
  final Widget acceptButton;
  final Widget rejectButton;

  const _PendingBanner({
    required this.message,
    required this.acceptButton,
    required this.rejectButton,
  });

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
              message,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 20),
          acceptButton,
          const SizedBox(width: 8),
          rejectButton,
        ],
      ),
    );
  }
}

class _PendingFinalProposalBanner extends StatelessWidget {
  const _PendingFinalProposalBanner();

  @override
  Widget build(BuildContext context) {
    return _PendingBanner(
      message: context.l10n.proposalViewPendingFinalProposalBannerMessage,
      acceptButton: const _AcceptFinalProposalButton(),
      rejectButton: const _RejectFinalProposalButton(),
    );
  }
}

class _PendingInvitationBanner extends StatelessWidget {
  const _PendingInvitationBanner();

  @override
  Widget build(BuildContext context) {
    return _PendingBanner(
      message: context.l10n.proposalViewPendingInvitationBannerMessage,
      acceptButton: const _AcceptInvitationButton(),
      rejectButton: const _RejectInvitationButton(),
    );
  }
}

class _RejectButton extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const _RejectButton({
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.outlined(
        style: style,
        onTap: onTap,
        child: VoicesAssets.icons.x.buildIcon(),
      ),
      sm: (context) => VoicesOutlinedButton(
        style: style,
        onTap: onTap,
        child: Text(message),
      ),
    );
  }
}

class _RejectedFinalProposalBanner extends StatelessWidget {
  const _RejectedFinalProposalBanner();

  @override
  Widget build(BuildContext context) {
    return _DismissibleBanner(
      icon: VoicesAssets.icons.check.buildIcon(color: Theme.of(context).colors.iconsSuccess),
      message: context.l10n.proposalViewRejectedFinalProposalBannerMessage,
      button: const _ChangeToAllowFinalProposalButton(),
    );
  }
}

class _RejectedInvitationBanner extends StatelessWidget {
  const _RejectedInvitationBanner();

  @override
  Widget build(BuildContext context) {
    return _DismissibleBanner(
      icon: VoicesAssets.icons.xCircle.buildIcon(color: Theme.of(context).colors.iconsError),
      message: context.l10n.proposalViewRejectedInvitationBannerMessage,
      button: const _ChangeToAllowInvitationButton(),
    );
  }
}

class _RejectFinalProposalButton extends StatelessWidget {
  const _RejectFinalProposalButton();

  @override
  Widget build(BuildContext context) {
    return _RejectButton(
      message: context.l10n.reject,
      onTap: () => _showDialog(context),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final rejected = await ProposalRejectFinalProposalDialog.show(context) ?? false;

    if (rejected && context.mounted) {
      unawaited(context.read<ProposalCubit>().rejectFinalProposal());
    }
  }
}

class _RejectInvitationButton extends StatelessWidget {
  const _RejectInvitationButton();

  @override
  Widget build(BuildContext context) {
    return _RejectButton(
      message: context.l10n.proposalViewPendingInvitationBannerRejectButton,
      onTap: () => _showDialog(context),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final rejected = await ProposalRejectInvitationDialog.show(context) ?? false;

    if (rejected && context.mounted) {
      unawaited(context.read<ProposalCubit>().rejectCollaboratorInvitation());
    }
  }
}
