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

class VotingTimelineHeaderSelector extends StatelessWidget {
  const VotingTimelineHeaderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      VotingCubit,
      VotingState,
      ({VotingTimelineDetailsViewModel? viewModel, bool phasesExpanded, bool showCategoryPicker})
    >(
      selector: (state) => (
        viewModel: state.votingTimeline,
        phasesExpanded: state.votingPhasesExpanded,
        showCategoryPicker: state.showCategoryPicker,
      ),
      builder: (context, data) {
        final viewModel = data.viewModel;
        if (viewModel == null || viewModel.phases.isEmpty) {
          return const SizedBox.shrink();
        }

        return _VotingTimelineHeader(
          viewModel: viewModel,
          phasesExpanded: data.phasesExpanded,
          showCategoryPicker: data.showCategoryPicker,
        );
      },
    );
  }
}

class _VotingTimelineHeader extends StatelessWidget {
  final VotingTimelineDetailsViewModel viewModel;
  final bool phasesExpanded;
  final bool showCategoryPicker;

  const _VotingTimelineHeader({
    required this.viewModel,
    required this.phasesExpanded,
    required this.showCategoryPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _VotingTimelineTitle(
          phaseType: viewModel.currentPhase.type,
          isExpanded: phasesExpanded,
          showCategoryPicker: showCategoryPicker,
        ),
        ClipRect(
          child: AnimatedAlign(
            duration: kThemeAnimationDuration,
            curve: Curves.easeInOut,
            alignment: Alignment.bottomCenter,
            heightFactor: phasesExpanded ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _VotingTimelinePhaseCards(phases: viewModel.phases),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _VotingTimelineProgressBar(progress: viewModel.currentPhaseProgress),
        const SizedBox(height: 6),
        _VotingTimelineFooter(viewModel: viewModel),
      ],
    );
  }
}

extension on VotingTimelinePhaseType {
  String getLabel(BuildContext context) {
    return switch (this) {
      VotingTimelinePhaseType.registration => context.l10n.votingTimelinePreVoting,
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineVoting,
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineTally,
      VotingTimelinePhaseType.results => context.l10n.votingTimelineResults,
    };
  }
}
