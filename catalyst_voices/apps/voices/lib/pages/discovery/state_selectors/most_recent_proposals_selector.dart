import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _StateData = ({bool show, LocalizedException? error});
typedef _ListItems = List<PendingProposal>;

class MostRecentProposalsSelector extends StatelessWidget {
  const MostRecentProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _MostRecentProposalsLoading(),
        _MostRecentProposalsData(),
        _MostRecentProposalsError(),
      ],
    );
  }
}

class _MostRecentProposalsLoading extends StatelessWidget {
  const _MostRecentProposalsLoading();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, bool>(
      selector: (state) {
        return state.mostRecentProposals.isLoading;
      },
      builder: (context, state) {
        final dummy = List.filled(
          7,
          PendingProposal.dummy(),
        );
        return Offstage(
          offstage: !state,
          child: MostRecentProposals(
            proposals: dummy,
            isLoading: true,
          ),
        );
      },
    );
  }
}

class _MostRecentProposalsData extends StatelessWidget {
  const _MostRecentProposalsData();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, _ListItems>(
      selector: (state) => state.mostRecentProposals.proposals,
      builder: (context, state) {
        return Offstage(
          offstage: state.length < 6,
          child: MostRecentProposals(proposals: state),
        );
      },
    );
  }
}

class _MostRecentProposalsError extends StatelessWidget {
  const _MostRecentProposalsError();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, _StateData>(
      selector: (state) {
        return (
          show: state.currentCampaign.showError,
          error: state.currentCampaign.error,
        );
      },
      builder: (context, state) {
        final errorMessage = state.error?.message(context);
        return Offstage(
          offstage: !state.show,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: VoicesErrorIndicator(
                message: errorMessage ?? context.l10n.somethingWentWrong,
                onRetry: () async {
                  await context.read<DiscoveryCubit>().getCurrentCampaign();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
