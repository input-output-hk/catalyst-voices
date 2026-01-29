import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/indicators/voices_progress_indicator_weight.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'voting_timeline_footer.dart';
part 'voting_timeline_phase_card.dart';
part 'voting_timeline_phase_cards.dart';
part 'voting_timeline_progress_bar.dart';
part 'voting_timeline_title.dart';

class VotingTimelineHeader extends StatelessWidget {
  const VotingTimelineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _VotingTimelineTitle(),
        ClipRect(
          child: _TimelinePhasesAnimation(
            child: _VotingTimelinePhaseCards(),
          ),
        ),
        SizedBox(height: 16),
        _VotingTimelineProgressBar(),
        SizedBox(height: 6),
        _VotingTimelineFooter(),
      ],
    );
  }
}

class _TimelinePhasesAnimation extends StatelessWidget {
  final Widget child;

  const _TimelinePhasesAnimation({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, bool>(
      selector: (state) => state.votingTimeline?.titleViewModel.phasesExpanded ?? true,
      builder: (context, expanded) => AnimatedAlign(
        duration: kThemeAnimationDuration,
        curve: Curves.easeInOut,
        alignment: Alignment.bottomCenter,
        heightFactor: expanded ? 1.0 : 0.0,
        child: child,
      ),
    );
  }
}

extension _VotingTimelinePhaseTypeLabel on VotingTimelinePhaseType {
  String getCountdownLabel(
    BuildContext context, {
    required String duration,
  }) {
    return switch (this) {
      VotingTimelinePhaseType.preVoting => context.l10n.votingTimelineVotingIn(duration),
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineTallyIn(duration),
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineResultsIn(duration),
      VotingTimelinePhaseType.results => context.l10n.votingTimelineNewFundComingSoon,
    };
  }

  String getDateWindowLabel(BuildContext context) {
    return switch (this) {
      VotingTimelinePhaseType.preVoting => context.l10n.votingTimelinePreVotingWindow,
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineVotingWindow,
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineTallyWindow,
      VotingTimelinePhaseType.results => context.l10n.votingTimelineResultsLabel,
    };
  }

  String getDescription(
    BuildContext context, {
    required bool isVotingDelegated,
  }) {
    if (isVotingDelegated && this == VotingTimelinePhaseType.voting) {
      return context.l10n.votingTimelineVotingDelegatedDescription;
    }
    return switch (this) {
      VotingTimelinePhaseType.preVoting => context.l10n.votingTimelinePreVotingDescription,
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineVotingDescription,
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineTallyDescription,
      VotingTimelinePhaseType.results => context.l10n.votingTimelineResultsDescription,
    };
  }

  String getLabel(
    BuildContext context, {
    required bool isVotingDelegated,
  }) {
    if (isVotingDelegated && this == VotingTimelinePhaseType.voting) {
      return context.l10n.votingTimelineDelegated;
    }
    return switch (this) {
      VotingTimelinePhaseType.preVoting => context.l10n.votingTimelinePreVoting,
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineVoting,
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineTally,
      VotingTimelinePhaseType.results => context.l10n.votingTimelineResults,
    };
  }
}
