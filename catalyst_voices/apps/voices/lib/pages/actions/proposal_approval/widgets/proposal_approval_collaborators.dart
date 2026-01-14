import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalContributors extends StatelessWidget {
  final List<Contributor> contributors;

  const ProposalApprovalContributors({
    super.key,
    required this.contributors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 22,
      ),
      child: Column(
        spacing: 16,
        children: [
          for (final contributor in contributors) _Contributor(contributor: contributor),
        ],
      ),
    );
  }
}

class _Contributor extends StatelessWidget {
  final Contributor contributor;

  const _Contributor({
    required this.contributor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        _StatusIcon(status: contributor.status),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              _NameAndCatalystId(catalystId: contributor.id),
              _StatusText(
                status: contributor.status,
                dateTime: contributor.createdAt,
                isAuthor: contributor.isAuthor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NameAndCatalystId extends StatelessWidget {
  final CatalystId catalystId;

  const _NameAndCatalystId({required this.catalystId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      spacing: 8,
      children: [
        Flexible(
          child: Text(
            catalystId.getDisplayName(context),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
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

class _StatusIcon extends StatelessWidget {
  final ProposalsCollaborationStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return status
        .icon(context)
        .buildIcon(
          size: 24,
          color: status.statusColor(context),
        );
  }
}

class _StatusText extends StatelessWidget {
  final ProposalsCollaborationStatus status;
  final DateTime? dateTime;
  final bool isAuthor;

  const _StatusText({
    required this.status,
    required this.dateTime,
    required this.isAuthor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      _format(context),
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colors.textOnPrimaryLevel1,
      ),
    );
  }

  // TODO(dt-iohk): check this against the figma
  String _format(BuildContext context) {
    final buffer = StringBuffer(status.proposalApprovalLabel(context));

    if (dateTime case final dateTime?) {
      buffer.write(' · ${DateFormatter.formatDayMonthTime(dateTime)}');
    }

    if (isAuthor) {
      buffer.write(' · ${context.l10n.you}');
    } else if (status == ProposalsCollaborationStatus.mainProposer) {
      buffer.write(' · ${context.l10n.mainProposer}');
    }

    return buffer.toString();
  }
}
