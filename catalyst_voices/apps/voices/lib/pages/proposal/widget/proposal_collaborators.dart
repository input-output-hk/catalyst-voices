import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices/widgets/user/profile_avatar.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalCollaborators extends StatelessWidget {
  final Collaborators collaborators;

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
            for (final collaborator in collaborators.collaborators)
              _Collaborator(
                collaborator: collaborator,
                showStatus: collaborators is AllCollaborators,
              ),
          ],
        ),
      ],
    );
  }
}

class _Collaborator extends StatelessWidget {
  final Collaborator collaborator;
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
          username: collaborator.id.username,
          size: 32,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Username(
              catalystId: collaborator.id,
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
  final ProposalsCollaborationStatus status;

  const _Status({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3.5,
      children: [
        CircleAvatar(
          radius: 4.5,
          backgroundColor: status.statusColor(context),
        ),
        Text(
          status.labelText(context),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: status.labelColor(context),
          ),
        ),
      ],
    );
  }
}

class _Username extends StatelessWidget {
  final CatalystId catalystId;
  final ProposalsCollaborationStatus status;

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
          catalystId.getDisplayName(context),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: status.labelColor(context),
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
}
