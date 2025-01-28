import 'package:catalyst_voices/pages/discovery/current_campaign.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _StateData = ({bool show, LocalizedException? error});

class CurrentCampaignSelector extends StatelessWidget {
  const CurrentCampaignSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        CurrentCampaignLoading(),
        CurrentCampaignData(),
        CurrentCampaignError(),
      ],
    );
  }
}

class CurrentCampaignLoading extends StatelessWidget {
  const CurrentCampaignLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, bool>(
      selector: (state) {
        return state.currentCampaign.isLoading;
      },
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: CurrentCampaign(
            currentCampaignInfo: const NullCurrentCampaignInfoViewModel(),
            isLoading: state,
          ),
        );
      },
    );
  }
}

class CurrentCampaignData extends StatelessWidget {
  const CurrentCampaignData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState,
        CurrentCampaignInfoViewModel>(
      selector: (state) {
        return state.currentCampaign.currentCampaign;
      },
      builder: (context, state) {
        return Offstage(
          offstage: state is NullCurrentCampaignInfoViewModel,
          child: CurrentCampaign(
            currentCampaignInfo: state,
          ),
        );
      },
    );
  }
}

class CurrentCampaignError extends StatelessWidget {
  const CurrentCampaignError({super.key});

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
