import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// To align columns in two different rows we let each row's column
/// hardcode the width so that they're horizontally aligned
/// when displayed one above the other.
const _votingPowerWidth = 192.0;

class AccountVotingPowerCard extends StatelessWidget {
  final VotingPowerViewModel votingPower;

  const AccountVotingPowerCard({
    super.key,
    required this.votingPower,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium!
        .copyWith(color: theme.colors.textOnPrimaryLevel1.withValues(alpha: 0.7));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoicesAssets.icons.lightningBolt.buildIcon(
            color: theme.colors.textOnPrimaryLevel1,
            size: 24,
          ),
          const Spacer(),
          _VotingPowerLabelRow(
            votingPower: votingPower,
            labelStyle: labelStyle,
          ),
          const SizedBox(height: 16),
          _VotingPowerValueRow(
            votingPower: votingPower,
            labelStyle: labelStyle,
          ),
        ],
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final VotingPowerStatus status;
  final TextStyle labelStyle;

  const _Status({
    required this.status,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          context.l10n.status,
          style: labelStyle,
        ),
        VoicesChip(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Theme.of(context).colors.onSurfacePrimary016,
          content: Text(
            _getStatusText(context),
            style: theme.textTheme.labelSmall!.copyWith(color: theme.colors.textOnPrimaryLevel1),
          ),
        ),
      ],
    );
  }

  String _getStatusText(BuildContext context) {
    return switch (status) {
      VotingPowerStatus.provisional => context.l10n.provisional,
      VotingPowerStatus.confirmed => context.l10n.confirmed,
    };
  }
}

class _UpdatedAt extends StatelessWidget {
  final DateTime updatedAt;
  final TextStyle labelStyle;

  const _UpdatedAt({
    required this.updatedAt,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          context.l10n.updated,
          style: labelStyle,
        ),
        TimezoneDateTimeText(
          updatedAt,
          formatter: (context, dateTime) => DateFormatter.formatFullDate24Format(dateTime),
          style: theme.textTheme.labelMedium!.copyWith(color: theme.colors.textOnPrimaryLevel1),
        ),
      ],
    );
  }
}

class _VotingPowerLabelRow extends StatelessWidget {
  final VotingPowerViewModel votingPower;
  final TextStyle labelStyle;

  const _VotingPowerLabelRow({
    required this.votingPower,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _votingPowerWidth,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              context.l10n.votingPower,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: theme.colors.textOnPrimaryLevel1,
              ),
            ),
          ),
        ),
        _Status(
          status: votingPower.status,
          labelStyle: labelStyle,
        ),
      ],
    );
  }
}

class _VotingPowerValueRow extends StatelessWidget {
  final VotingPowerViewModel votingPower;
  final TextStyle labelStyle;

  const _VotingPowerValueRow({
    required this.votingPower,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _votingPowerWidth,
          child: Text(
            votingPower.amount,
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
        ),
        _UpdatedAt(
          updatedAt: votingPower.updatedAt,
          labelStyle: labelStyle,
        ),
      ],
    );
  }
}
