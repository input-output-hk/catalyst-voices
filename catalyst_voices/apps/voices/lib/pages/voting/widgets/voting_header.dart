import 'package:catalyst_voices/widgets/specialized/voting/account_voting_power_card.dart';
import 'package:catalyst_voices/widgets/specialized/voting/voting_phase_progress_card.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.catalystF15,
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const _CategoryPicker(),
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
    return BlocSelector<VotingCubit, VotingState, VotingPowerViewModel?>(
      selector: (state) => state.votingPower,
      builder: (context, votingPower) {
        if (votingPower == null) {
          return const Offstage();
        }

        return AccountVotingPowerCard(votingPower: votingPower);
      },
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker();

  @override
  Widget build(BuildContext context) {
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
    return BlocSelector<VotingCubit, VotingState, VotingPhaseProgressViewModel?>(
      selector: (state) => state.votingPhase,
      builder: (context, votingPhase) {
        if (votingPhase == null) {
          return const Offstage();
        }

        final width = (MediaQuery.sizeOf(context).width * 0.35).clamp(_minWidth, _maxWidth);
        return SizedBox(
          width: width,
          child: VotingPhaseProgressCard(votingPhase: votingPhase),
        );
      },
    );
  }
}
