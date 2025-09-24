import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class MostRecentProposalsSelector extends StatelessWidget {
  static const _minProposalsToShowRecent = 6;

  const MostRecentProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, DiscoveryMostRecentProposalsState>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        final hasMinProposalsToShow = state.proposals.length > _minProposalsToShowRecent;
        return Stack(
          children: [
            _MostRecentProposalsError(state),
            _ViewAllProposals(
              offstage: state.showError || !hasMinProposalsToShow,
            ),
            _MostRecentProposalsData(
              state,
              minProposalsToShow: hasMinProposalsToShow,
            ),
          ],
        );
      },
    );
  }
}

class _MostRecentProposalsData extends StatelessWidget {
  final DiscoveryMostRecentProposalsState state;
  final bool minProposalsToShow;

  const _MostRecentProposalsData(this.state, {this.minProposalsToShow = false});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      key: const Key('MostRecentProposalsData'),
      offstage: state.showError || !minProposalsToShow,
      child: MostRecentProposals(proposals: state.proposals),
    );
  }
}

class _MostRecentProposalsError extends StatelessWidget {
  final DiscoveryMostRecentProposalsState state;

  const _MostRecentProposalsError(this.state);

  @override
  Widget build(BuildContext context) {
    final errorMessage = state.error?.message(context);
    return Offstage(
      key: const Key('MostRecentError'),
      offstage: !state.showError,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: VoicesErrorIndicator(
            message: errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: () async {
              await context.read<DiscoveryCubit>().getMostRecentProposals();
            },
          ),
        ),
      ),
    );
  }
}

class _ViewAllProposals extends StatelessWidget {
  final bool offstage;

  const _ViewAllProposals({this.offstage = true});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      key: const Key('MostRecentProposalsData'),
      offstage: !offstage,
      child: const ViewAllProposals(),
    );
  }
}
