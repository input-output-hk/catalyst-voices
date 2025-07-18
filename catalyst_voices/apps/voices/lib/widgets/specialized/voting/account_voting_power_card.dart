import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountVotingPowerCard extends StatelessWidget {
  final VotingPowerViewModel votingPower;

  const AccountVotingPowerCard({
    super.key,
    required this.votingPower,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        spacing: 48,
        children: [
          VoicesAssets.icons.lightningBolt.buildIcon(
            color: theme.colors.textOnPrimaryLevel1,
            size: 24,
          ),
          Row(
            spacing: 48,
            children: [
              _VotingPower(votingPower: votingPower.power),
              _StatusAndUpdated(
                status: votingPower.status,
                updatedAt: votingPower.updatedAt,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final VotingPowerStatus status;
  final TextStyle style;

  const _Status({
    required this.status,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip(
      content: Text(_getStatusText(context), style: style),
      borderRadius: BorderRadius.circular(4),
    );
  }

  String _getStatusText(BuildContext context) {
    return switch (status) {
      VotingPowerStatus.provisional => context.l10n.provisional,
      VotingPowerStatus.confirmed => context.l10n.confirmed,
    };
  }
}

class _StatusAndUpdated extends StatelessWidget {
  final VotingPowerStatus status;
  final DateTime updatedAt;

  const _StatusAndUpdated({
    required this.status,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium!
        .copyWith(color: theme.colors.textOnPrimaryLevel1.withAlpha(178));
    final valueStyle = labelStyle.copyWith(color: theme.colors.textOnPrimaryLevel1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.status,
          style: labelStyle,
        ),
        const SizedBox(height: 4),
        _Status(
          status: status,
          style: valueStyle,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.updated,
          style: labelStyle,
        ),
        const SizedBox(height: 4),
        _UpdatedAt(
          updatedAt: updatedAt,
          style: valueStyle,
        ),
      ],
    );
  }
}

class _UpdatedAt extends StatelessWidget {
  final DateTime updatedAt;
  final TextStyle style;

  const _UpdatedAt({
    required this.updatedAt,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      updatedAt,
      formatter: (context, dateTime) => DateFormatter.formatFullDate24Format(dateTime),
      style: style,
    );
  }
}

class _VotingPower extends StatelessWidget {
  final String votingPower;

  const _VotingPower({required this.votingPower});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32,
      children: [
        Text(
          context.l10n.votingPower,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        Text(
          votingPower,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
