import 'package:catalyst_voices/common/ext/active_fund_number_selector_ext.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/discovery/sections/current_campaign.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CurrentCampaignData extends StatelessWidget {
  const CurrentCampaignData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, CurrentCampaignInfoViewModel>(
      key: const Key('CurrentCampaignData'),
      selector: (state) {
        return state.campaign.currentCampaign;
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
    return BlocSelector<DiscoveryCubit, DiscoveryState, ErrorVisibilityState>(
      selector: (state) {
        return (
          show: state.campaign.showError,
          data: state.campaign.error,
        );
      },
      builder: (context, state) {
        final errorMessage = state.data?.message(context);
        return Offstage(
          key: const Key('CurrentCampaignError'),
          offstage: !state.show,
          child: Padding(
            padding: const EdgeInsets.all(32),
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

class CurrentCampaignLoading extends StatelessWidget {
  const CurrentCampaignLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, bool>(
      selector: (state) {
        return state.campaign.isLoading;
      },
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: CurrentCampaign(
            currentCampaignInfo: NullCurrentCampaignInfoViewModel(),
            isLoading: state,
          ),
        );
      },
    );
  }
}

class CurrentCampaignSelector extends StatelessWidget {
  const CurrentCampaignSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('CurrentCampaignRoot'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsivePadding(
          xs: const EdgeInsets.only(left: 20, top: 64, right: 20),
          sm: const EdgeInsets.only(left: 42, top: 64, right: 42),
          md: const EdgeInsets.only(left: 120, top: 64, right: 120),
          child: const _Header(),
        ),
        const Stack(
          children: [
            CurrentCampaignLoading(),
            CurrentCampaignData(),
            CurrentCampaignError(),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 568),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            key: const Key('CurrentCampaignTitle'),
            context.l10n.currentCampaign,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            key: const Key('Subtitle'),
            context.l10n.catalystFundNo(context.activeCampaignFundNumber),
            style: context.textTheme.displayMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            key: const Key('Description'),
            context.l10n.currentCampaignDescription,
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
