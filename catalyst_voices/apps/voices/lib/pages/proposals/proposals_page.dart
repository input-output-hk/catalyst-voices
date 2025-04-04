import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/pages/proposals/proposal_pagination_tabview.dart';
import 'package:catalyst_voices/pages/proposals/widgets/category_selector.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs.dart';
import 'package:catalyst_voices/routes/routes.dart';
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
  final ProposalsFilterType? type;

  const ProposalsPage({
    super.key,
    this.categoryId,
    this.selectMyProposalsView = false,
    this.type,
  });

  @override
  State<ProposalsPage> createState() => _ProposalsPageState();
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

class _ProposalsPageState extends State<ProposalsPage>
    with
        SingleTickerProviderStateMixin,
        SignalHandlerStateMixin<ProposalsCubit, ProposalsSignal,
            ProposalsPage> {
  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 32)
              .add(const EdgeInsets.only(bottom: 32)),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 16),
                const _Header(),
                const SizedBox(height: 40),
                _Tabs(controller: _tabController),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(ProposalsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoryId != oldWidget.categoryId ||
        widget.selectMyProposalsView != oldWidget.selectMyProposalsView ||
        widget.type != oldWidget.type) {
      context.read<ProposalsCubit>().changeFilters(
            onlyMy: widget.selectMyProposalsView,
            category: widget.categoryId,
            type: widget.type ?? ProposalsFilterType.total,
          );
    }

    if (widget.type != oldWidget.type) {
      _tabController.animateTo(widget.type?.index ?? 0);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void handleSignal(ProposalsSignal signal) {
    switch (signal) {
      case ChangeCategorySignal(:final to):
        _updateRoute(categoryId: Optional(to?.id));
      case ChangeFilterType(:final type):
        _updateRoute(filterType: type);
    }
  }

  @override
  void initState() {
    super.initState();

    final proposalsFilterType = widget.type ?? ProposalsFilterType.total;

    _tabController = TabController(
      initialIndex: proposalsFilterType.index,
      length: ProposalsFilterType.values.length,
      vsync: this,
    );

    context.read<ProposalsCubit>().init(
          onlyMyProposals: widget.selectMyProposalsView,
          category: widget.categoryId,
          type: proposalsFilterType,
        );
  }

  void _updateRoute({
    Optional<String>? categoryId,
    ProposalsFilterType? filterType,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryId?.id);
      final effectiveType = filterType?.name ?? widget.type?.name;

      if (widget.selectMyProposalsView) {
        MyProposalsRoute(categoryId: effectiveCategoryId, type: effectiveType)
            .replace(context);
      } else {
        ProposalsRoute(categoryId: effectiveCategoryId, type: effectiveType)
            .replace(context);
      }
    });
  }
}

class _Tabs extends StatelessWidget {
  final TabController controller;

  const _Tabs({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            runSpacing: 10,
            children: [
              ProposalsTabs(controller: controller),
              const _Controls(),
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
          controller: controller,
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
    );
  }
}
