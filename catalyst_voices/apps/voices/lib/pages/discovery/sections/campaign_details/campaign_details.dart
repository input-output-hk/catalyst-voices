import 'package:catalyst_voices/common/ext/active_fund_number_selector_ext.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_details/widgets/campaign_categories.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_details/widgets/current_campaign.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignDetails extends StatelessWidget {
  const CampaignDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, DiscoveryCampaignState>(
      selector: (state) => state.campaign,
      builder: (context, campaign) {
        return _CampaignDetails(campaign);
      },
    );
  }
}

class _CampaignCategoriesContent extends StatelessWidget {
  final List<CampaignCategoryDetailsViewModel> categories;
  final bool isLoading;

  const _CampaignCategoriesContent({
    required this.categories,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesToShow = categories.isEmpty
        ? List.filled(4, CampaignCategoryDetailsViewModel.placeholder())
        : categories;

    return CampaignCategories(
      key: const Key('CampaignCategoriesData'),
      categoriesToShow,
      isLoading: isLoading,
    );
  }
}

class _CampaignData extends StatelessWidget {
  final DiscoveryCampaignState campaignState;

  const _CampaignData({required this.campaignState});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('CampaignDetailsRoot'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 120, top: 64, right: 120),
          child: _CurrentCampaignHeader(),
        ),
        _CurrentCampaignContent(
          currentCampaign: campaignState.currentCampaign ?? NullCurrentCampaignInfoViewModel(),
          isLoading: campaignState.isLoading,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: Text(
            key: const Key('CampaignCategoriesTitle'),
            context.l10n.campaignCategories,
            style: context.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 24),
        _CampaignCategoriesContent(
          categories: campaignState.categories,
          isLoading: campaignState.isLoading,
        ),
      ],
    );
  }
}

class _CampaignDetails extends StatelessWidget {
  final DiscoveryCampaignState campaign;

  const _CampaignDetails(this.campaign);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: campaign.showError,
          child: _CampaignData(campaignState: campaign),
        ),
        Offstage(
          offstage: !campaign.showError,
          child: _CampaignError(
            error: campaign.error,
            onRetry: () async {
              await context.read<DiscoveryCubit>().getCurrentCampaign();
            },
          ),
        ),
      ],
    );
  }
}

class _CampaignError extends StatelessWidget {
  final LocalizedException? error;
  final VoidCallback onRetry;

  const _CampaignError({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = error?.message(context);
    return Padding(
      key: const Key('CampaignError'),
      padding: const EdgeInsets.all(32),
      child: Center(
        child: VoicesErrorIndicator(
          message: errorMessage ?? context.l10n.somethingWentWrong,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _CurrentCampaignContent extends StatelessWidget {
  final CurrentCampaignInfoViewModel currentCampaign;
  final bool isLoading;

  const _CurrentCampaignContent({
    required this.currentCampaign,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CurrentCampaign(
      key: const Key('CurrentCampaignData'),
      currentCampaignInfo: currentCampaign,
      isLoading: isLoading,
    );
  }
}

class _CurrentCampaignHeader extends StatelessWidget {
  const _CurrentCampaignHeader();

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
