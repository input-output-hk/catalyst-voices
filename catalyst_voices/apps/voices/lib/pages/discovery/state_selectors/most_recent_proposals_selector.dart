import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

typedef _ListItems = List<PendingProposal>;

class MostRecentProposalsSelector extends StatelessWidget {
  const MostRecentProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _MostRecentProposalsLoading(),
        _MostRecentProposalsError(),
        _MostRecentProposalsData(),
      ],
    );
  }
}

class _MostRecentProposalsData extends StatelessWidget {
  static const _minProposalsToShowRecent = 6;

  const _MostRecentProposalsData();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, _ListItems>(
      selector: (state) => state.proposals.proposals,
      builder: (context, state) {
        if (state.length < _minProposalsToShowRecent) {
          return const ViewAllProposals();
        }
        return MostRecentProposals(proposals: state);
      },
    );
  }
}

class _MostRecentProposalsError extends StatelessWidget {
  const _MostRecentProposalsError();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, ErrorVisibilityState>(
      selector: (state) {
        return (
          show: state.proposals.showError,
          data: state.proposals.error,
        );
      },
      builder: (context, state) {
        final errorMessage = state.data?.message(context);
        return Offstage(
          key: const Key('MostRecentError'),
          offstage: !state.show,
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
      },
    );
  }
}

class _MostRecentProposalsLoading extends StatelessWidget {
  const _MostRecentProposalsLoading();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, bool>(
      selector: (state) {
        return state.proposals.isLoading;
      },
      builder: (context, state) {
        return const Offstage();
      },
    );
  }
}
