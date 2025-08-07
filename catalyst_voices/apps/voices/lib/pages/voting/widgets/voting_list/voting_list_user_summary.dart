import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_power_status_chip.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListUserSummary extends StatelessWidget {
  const VotingListUserSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingListUserSummaryData>(
      selector: (state) => state.userSummary,
      builder: (context, state) {
        return _VotingListUserSummary(data: state);
      },
    );
  }
}

class _VotingListUserSummary extends StatelessWidget {
  final VotingListUserSummaryData data;

  const _VotingListUserSummary({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VotingListUserSummaryTotalVotingPower(
            amount: data.amount,
            status: data.status,
          ),
        ],
      ),
    );
  }
}

class _VotingListUserSummaryTotalVotingPower extends StatelessWidget {
  final int amount;
  final VotingPowerStatus? status;

  const _VotingListUserSummaryTotalVotingPower({
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const Expanded(child: _VotingListUserSummaryTotalVotingPowerText()),
        _VotingListUserSummaryTotalVotingPowerValueAndStatus(amount: amount, status: status),
      ],
    );
  }
}

class _VotingListUserSummaryTotalVotingPowerText extends StatelessWidget {
  const _VotingListUserSummaryTotalVotingPowerText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.totalVotingPower,
      maxLines: 1,
      textAlign: TextAlign.start,
      style: context.textTheme.bodySmall?.copyWith(color: context.colors.textOnPrimaryLevel1),
    );
  }
}

class _VotingListUserSummaryTotalVotingPowerValueAndStatus extends StatelessWidget {
  final int amount;
  final VotingPowerStatus? status;

  const _VotingListUserSummaryTotalVotingPowerValueAndStatus({
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AffixDecorator(
      suffix: VotingPowerStatusChip(status: status),
      // TODO(damian-molinski): formatting of voting power
      child: Text(
        '$amount',
        style: (context.textTheme.titleMedium ?? const TextStyle()).copyWith(
          color: context.colors.textOnPrimaryLevel1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
