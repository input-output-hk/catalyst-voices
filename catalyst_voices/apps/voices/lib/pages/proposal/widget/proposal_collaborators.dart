import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices/widgets/user/profile_avatar.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalCollaborators extends StatelessWidget {
  final CollaboratorInvitesState collaborators;

  const ProposalCollaborators({
    super.key,
    required this.collaborators,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          '${context.l10n.coproposers}:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            for (final collaborator in collaborators.invites)
              _Collaborator(
                collaborator: collaborator,
                showStatus: collaborators is AllCollaboratorInvites,
              ),
          ],
        ),
      ],
    );
  }
}

class _Collaborator extends StatelessWidget {
  final CollaboratorInvite collaborator;
  final bool showStatus;

  const _Collaborator({
    required this.collaborator,
    required this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ProfileAvatar(
          username: collaborator.catalystId.username,
          size: 32,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Username(
              catalystId: collaborator.catalystId,
              status: collaborator.status,
            ),
            if (showStatus) _Status(status: collaborator.status),
          ],
        ),
      ],
    );
  }
}

class _Status extends StatelessWidget {
  final CollaboratorInviteStatus status;

  const _Status({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3.5,
      children: [
        CircleAvatar(
          radius: 4.5,
          backgroundColor: _getCircleColor(context),
        ),
        Text(
          _getStatusText(context),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _getTextColor(context),
          ),
        ),
      ],
    );
  }

  Color _getCircleColor(BuildContext context) {
    return switch (status) {
      CollaboratorInviteStatus.pending => const Color(0xFFB5B5B5),
      CollaboratorInviteStatus.accepted => Theme.of(context).colors.iconsSuccess,
      CollaboratorInviteStatus.rejected ||
      CollaboratorInviteStatus.removed => Theme.of(context).colors.iconsError,
      CollaboratorInviteStatus.left => Theme.of(context).colors.iconsDisabled,
    };
  }

  String _getStatusText(BuildContext context) {
    return switch (status) {
      CollaboratorInviteStatus.pending => context.l10n.collaboratorInvitationStatusPending,
      CollaboratorInviteStatus.accepted => context.l10n.collaboratorInvitationStatusAccepted,
      CollaboratorInviteStatus.rejected => context.l10n.collaboratorInvitationStatusRejected,
      CollaboratorInviteStatus.left => context.l10n.collaboratorInvitationStatusLeft,
      CollaboratorInviteStatus.removed => context.l10n.collaboratorInvitationStatusRemoved,
    };
  }

  Color _getTextColor(BuildContext context) {
    return switch (status) {
      CollaboratorInviteStatus.pending ||
      CollaboratorInviteStatus.accepted ||
      CollaboratorInviteStatus.rejected ||
      CollaboratorInviteStatus.removed => Theme.of(context).colors.textOnPrimaryLevel1,
      CollaboratorInviteStatus.left => Theme.of(context).colors.textDisabled,
    };
  }
}

class _Username extends StatelessWidget {
  final CatalystId catalystId;
  final CollaboratorInviteStatus status;

  const _Username({
    required this.catalystId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          catalystId.username ?? context.l10n.anonymousUsername,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: _getTextColor(context),
          ),
        ),
        CatalystIdText(
          catalystId,
          isCompact: true,
          showCopy: false,
        ),
      ],
    );
  }

  Color _getTextColor(BuildContext context) {
    return switch (status) {
      CollaboratorInviteStatus.pending ||
      CollaboratorInviteStatus.accepted ||
      CollaboratorInviteStatus.rejected ||
      CollaboratorInviteStatus.removed => Theme.of(context).colors.textOnPrimaryLevel1,
      CollaboratorInviteStatus.left => Theme.of(context).colors.textDisabled,
    };
  }
}
