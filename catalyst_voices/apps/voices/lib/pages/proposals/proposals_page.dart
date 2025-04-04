import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/pages/proposals/proposal_pagination_tabview.dart';
import 'package:catalyst_voices/pages/proposals/widgets/category_selector.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs.dart';
import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsPage extends StatefulWidget {
  final SignedDocumentRef? categoryId;
  final bool selectMyProposalsView;

  const ProposalsPage({
    super.key,
    this.categoryId,
    this.selectMyProposalsView = false,
  });

  @override
  State<ProposalsPage> createState() => _ProposalsPageState();
}

class _ActiveAccountBody extends StatelessWidget {
  const _ActiveAccountBody();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32)
          .add(const EdgeInsets.only(bottom: 32)),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            const SizedBox(height: 16),
            const _Header(),
            const SizedBox(height: 40),
            const _Tabs(),
          ],
        ),
      ),
    );
  }
}

class _CampaignDetailsButton extends StatelessWidget {
  const _CampaignDetailsButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignInfoCubit, CampaignInfoState, String?>(
      selector: (state) => state.campaign?.id,
      builder: (context, campaignId) {
        return Offstage(
          offstage: campaignId == null,
          child: Padding(
            key: const Key('CampaignDetailsButton'),
            padding: const EdgeInsets.only(top: 32),
            child: OutlinedButton.icon(
              onPressed: () {
                if (campaignId == null) {
                  throw ArgumentError('Campaign ID is null');
                }
                unawaited(
                  CampaignDetailsDialog.show(context, id: campaignId),
                );
              },
              label: Text(context.l10n.campaignDetails),
              icon: VoicesAssets.icons.arrowsExpand.buildIcon(),
            ),
          ),
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategorySelector(),
          const SizedBox(width: 8),
          SearchTextField(
            key: const Key('SearchProposalsField'),
            hintText: context.l10n.searchProposals,
            showClearButton: true,
            onSearch: ({
              required searchValue,
              required isSubmitted,
            }) {
              context.read<ProposalsCubit>().changeSearchValue(searchValue);
            },
          ),
        ],
      ),
    );
  }
}

class _FundInfo extends StatelessWidget {
  const _FundInfo();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            key: const Key('CurrentCampaignTitle'),
            context.l10n.catalystF14,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            key: const Key('CurrentCampaignDescription'),
            context.l10n.currentCampaignDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const _CampaignDetailsButton(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationBack(),
        SizedBox(height: 40),
        _FundInfo(),
      ],
    );
  }
}

class _ProposalsPageState extends State<ProposalsPage> {
  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _ActiveAccountBody(),
      ],
    );
  }

  @override
  void didUpdateWidget(ProposalsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoryId != oldWidget.categoryId) {
      context.read<ProposalsCubit>().changeCategory(widget.categoryId);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProposalsCubit>().init(category: widget.categoryId);
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              runSpacing: 10,
              children: [
                ProposalsTabs(),
                _Controls(),
              ],
            ),
          ),
          Offstage(
            offstage: MediaQuery.sizeOf(context).width < 1400,
            child: Container(
              height: 1,
              width: double.infinity,
              color: context.colors.primaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          TabBarStackView(
            key: const Key('ProposalsTabBarStackView'),
            children: [
              BlocSelector<ProposalsCubit, ProposalsState,
                  ProposalPaginationViewModel>(
                selector: (state) {
                  return ProposalPaginationViewModel.fromPaginationItems(
                    paginItems: state.allProposals,
                    isLoading: state.allProposals.isLoading,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalPaginationTabView(
                    paginationViewModel: state,
                  );
                },
              ),
              BlocSelector<ProposalsCubit, ProposalsState,
                  ProposalPaginationViewModel>(
                selector: (state) {
                  return ProposalPaginationViewModel.fromPaginationItems(
                    paginItems: state.draftProposals,
                    isLoading: state.draftProposals.isLoading,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalPaginationTabView(
                    key: const Key('draftProposalsPagination'),
                    paginationViewModel: state,
                    stage: ProposalPublish.publishedDraft,
                  );
                },
              ),
              BlocSelector<ProposalsCubit, ProposalsState,
                  ProposalPaginationViewModel>(
                selector: (state) {
                  return ProposalPaginationViewModel.fromPaginationItems(
                    paginItems: state.finalProposals,
                    isLoading: state.finalProposals.isLoading,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalPaginationTabView(
                    key: const Key('finalProposalsPagination'),
                    paginationViewModel: state,
                    stage: ProposalPublish.submittedProposal,
                  );
                },
              ),
              BlocSelector<ProposalsCubit, ProposalsState,
                  ProposalPaginationViewModel>(
                selector: (state) {
                  return ProposalPaginationViewModel.fromPaginationItems(
                    paginItems: state.favoriteProposals,
                    isLoading: state.favoriteProposals.isLoading,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalPaginationTabView(
                    key: const Key('favoriteProposalsPagination'),
                    paginationViewModel: state,
                    usersFavorite: true,
                  );
                },
              ),
              BlocSelector<ProposalsCubit, ProposalsState,
                  ProposalPaginationViewModel>(
                selector: (state) {
                  return ProposalPaginationViewModel.fromPaginationItems(
                    paginItems: state.userProposals,
                    isLoading: state.userProposals.isLoading,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalPaginationTabView(
                    key: const Key('userProposalsPagination'),
                    paginationViewModel: state,
                    userProposals: true,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
