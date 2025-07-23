import 'package:catalyst_voices/pages/voting/widgets/account_voting_power_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_phase_progress_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingHeader extends StatelessWidget {
  const VotingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Text(
          context.l10n.spaceVotingName,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CatalystFund(),
            _CategoryPicker(),
          ],
        ),
        const SizedBox(height: 32),
        const SizedBox(
          height: 192,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              _VotingPhaseCard(),
              _AccountVotingPowerCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountVotingPowerCard extends StatelessWidget {
  const _AccountVotingPowerCard();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingPowerViewModel>(
      selector: (state) => state.votingPower,
      builder: (context, votingPower) => AccountVotingPowerCard(votingPower: votingPower),
    );
  }
}

class _CatalystFund extends StatelessWidget {
  const _CatalystFund();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, int?>(
      selector: (state) => state.fundNumber,
      builder: (context, fundNumber) {
        final theme = Theme.of(context);
        return Text(
          context.l10n.catalystFundNo(fundNumber?.toString() ?? ''),
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker();

  @override
  Widget build(BuildContext context) {
    // TODO(dt-iohk): implement in https://github.com/input-output-hk/catalyst-voices/issues/2965
    return const SizedBox(
      width: 100,
      height: 50,
      child: Placeholder(),
    );
  }
}

class _VotingPhaseCard extends StatelessWidget {
  static const _minWidth = 256.0;
  static const _maxWidth = 570.0;

  const _VotingPhaseCard();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingPhaseProgressViewModel>(
      selector: (state) => state.votingPhase,
      builder: (context, votingPhase) {

        final width = (MediaQuery.sizeOf(context).width * 0.35).clamp(_minWidth, _maxWidth);
        return SizedBox(
          width: width,
          child: VotingPhaseProgressCard(votingPhase: votingPhase),
        );
      },
    );
  }
}
