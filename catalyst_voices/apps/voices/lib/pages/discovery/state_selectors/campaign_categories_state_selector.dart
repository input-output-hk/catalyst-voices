import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_categories.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _ListItems = List<CampaignCategoryDetailsViewModel>;

class CampaignCategoriesStateSelector extends StatelessWidget {
  const CampaignCategoriesStateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('CampaignCategoriesStateSelector'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: Text(
            key: const Key('CampaignCategoriesTitle'),
            context.l10n.campaignCategories,
            style: context.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 24),
        const Stack(
          children: [
            _CampaignCategoriesLoading(),
            _CampaignCategoriesData(),
            _CampaignCategoriesError(),
          ],
        ),
      ],
    );
  }
}

class _CampaignCategoriesData extends StatelessWidget {
  const _CampaignCategoriesData();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, _ListItems>(
      selector: (state) {
        return state.campaignCategories.categories;
      },
      builder: (context, state) {
        return Offstage(
          offstage: state.isEmpty,
          child: CampaignCategories(
            state,
          ),
        );
      },
    );
  }
}

class _CampaignCategoriesError extends StatelessWidget {
  const _CampaignCategoriesError();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, VisibilityState>(
      selector: (state) => (
        show: state.campaignCategories.showError,
        error: state.campaignCategories.error
      ),
      builder: (context, state) {
        final errorMessage = state.error?.message(context);
        return Offstage(
          key: const Key('CampaignCategoriesError'),
          offstage: !state.show,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: VoicesErrorIndicator(
                message: errorMessage ?? context.l10n.somethingWentWrong,
                onRetry: () async {
                  await context.read<DiscoveryCubit>().getCampaignCategories();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CampaignCategoriesLoading extends StatelessWidget {
  const _CampaignCategoriesLoading();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, bool>(
      selector: (state) {
        return state.campaignCategories.isLoading;
      },
      builder: (context, isLoading) {
        final dummyCategories = List.filled(
          6,
          CampaignCategoryDetailsViewModel.dummy(),
        );
        return Offstage(
          offstage: !isLoading,
          child: CampaignCategories(dummyCategories, isLoading: isLoading),
        );
      },
    );
  }
}
