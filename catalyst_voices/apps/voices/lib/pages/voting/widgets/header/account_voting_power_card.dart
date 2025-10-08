import 'package:catalyst_voices/pages/voting/widgets/voting_power_status_chip.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// To align columns in two different rows we let each row's column
/// hardcode the width so that they're horizontally aligned
/// when displayed one above the other.
const _votingPowerWidth = 192.0;

class AccountVotingPowerCardSelector extends StatelessWidget {
  const AccountVotingPowerCardSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingPowerViewModel>(
      selector: (state) => state.votingPower,
      builder: (context, votingPower) => _AccountVotingPowerCard(votingPower: votingPower),
    );
  }
}

class _AccountVotingPowerCard extends StatelessWidget {
  final VotingPowerViewModel votingPower;

  const _AccountVotingPowerCard({
    required this.votingPower,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colors.textOnPrimaryLevel1.withValues(alpha: 0.7),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoicesAssets.icons.lightningBolt.buildIcon(
            color: theme.colors.textOnPrimaryLevel1,
            size: 24,
          ),
          const SizedBox(height: 40),
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
  final VotingPowerStatus? status;
  final TextStyle labelStyle;

  const _Status({
    required this.status,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          context.l10n.status,
          style: labelStyle,
        ),
        VotingPowerStatusChip(status: status),
      ],
    );
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Text(
          context.l10n.updated,
          style: labelStyle,
        ),
        ResponsiveBuilder<Axis>(
          xs: Axis.vertical,
          sm: Axis.horizontal,
          builder: (context, axis) {
            return TimezoneDateTimeText(
              updatedAt,
              formatter: (context, dateTime) => DateFormatter.formatFullDate24Format(dateTime),
              style: theme.textTheme.labelMedium!.copyWith(color: theme.colors.textOnPrimaryLevel1),
              axis: axis,
            );
          },
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
        Flexible(
          child: _Status(
            status: votingPower.status,
            labelStyle: labelStyle,
          ),
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
        Flexible(
          child: _UpdatedAt(
            updatedAt: votingPower.updatedAt ?? DateTimeExt.now(),
            labelStyle: labelStyle,
          ),
        ),
      ],
    );
  }
}
