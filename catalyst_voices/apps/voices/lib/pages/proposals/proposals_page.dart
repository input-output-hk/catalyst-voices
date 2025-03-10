import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/pages/proposals/proposal_pagination_tabview.dart';
import 'package:catalyst_voices/widgets/dropdown/category_dropdown.dart';
import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _CategoryButtonSelector = ({
  List<DropdownMenuViewModel> categories,
  String selectedName,
});

typedef _ProposalsCount = ({
  int total,
  int draft,
  int finals,
  int favorites,
  int my,
});

class ProposalsPage extends StatefulWidget {
  final String? categoryId;
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

class _ChangeCategoryButton extends StatefulWidget {
  final List<DropdownMenuViewModel> items;
  final String selectedName;
  final ValueChanged<String?>? onChanged;

  const _ChangeCategoryButton({
    required this.items,
    required this.selectedName,
    this.onChanged,
    super.key,
  });

  @override
  State<_ChangeCategoryButton> createState() => _ChangeCategoryButtonState();
}

class _ChangeCategoryButtonSelector extends StatelessWidget {
  const _ChangeCategoryButtonSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState,
        _CategoryButtonSelector>(
      selector: (state) {
        final dropdownItems = state.categories
            .map(
              (e) => DropdownMenuViewModel(
                name: e.formattedName,
                value: e.id,
                isSelected: e.id == state.selectedCategoryId,
              ),
            )
            .toList();
        final dropdownCategories = [
          DropdownMenuViewModel(
            name: context.l10n.showAll,
            value: '-1',
            isSelected: state.selectedCategoryId == null,
          ),
          ...dropdownItems,
        ];
        final selectedName =
            dropdownCategories.firstWhereOrNull((e) => e.isSelected)?.name ??
                context.l10n.showAll;
        return (
          categories: dropdownCategories,
          selectedName: selectedName,
        );
      },
      builder: (context, state) {
        return _ChangeCategoryButton(
          key: const Key('ChangeCategoryBtnSelector'),
          items: state.categories,
          selectedName: state.selectedName,
          onChanged: (value) {
            final categoryId = value == '-1' ? null : value;
            context.read<ProposalsCubit>().changeSelectedCategory(categoryId);
          },
        );
      },
    );
  }
}

class _ChangeCategoryButtonState extends State<_ChangeCategoryButton> {
  final GlobalKey<PopupMenuButtonState<dynamic>> _popupMenuButtonKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CategoryDropdown(
      items: widget.items,
      popupMenuButtonKey: _popupMenuButtonKey,
      highlightColor: context.colors.onSurfacePrimary08,
      onSelected: widget.onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1White,
          border: Border.all(color: context.colors.outlineBorderVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              key: const Key('CategorySelectorLabel'),
              context.l10n.category,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textDisabled,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              key: const Key('CategorySelectorValue'),
              widget.selectedName,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(width: 8),
            VoicesAssets.icons.chevronDown.buildIcon(),
          ],
        ),
      ),
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
          const _ChangeCategoryButtonSelector(),
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
    if (oldWidget.categoryId != widget.categoryId) {
      context.read<ProposalsCubit>().changeSelectedCategory(widget.categoryId);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProposalsCubit>().changeSelectedCategory(widget.categoryId);
    unawaited(context.read<CampaignInfoCubit>().load());
    unawaited(
      context.read<ProposalsCubit>().getFavoritesList(),
    );
    unawaited(
      context.read<ProposalsCubit>().getUserProposalsList(),
    );
    unawaited(context.read<ProposalsCubit>().getCampaignCategories());
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, _ProposalsCount>(
      selector: (state) {
        return (
          total: state.allProposals.maxResults,
          draft: state.draftProposals.maxResults,
          finals: state.finalProposals.maxResults,
          favorites: state.favoritesIds.length,
          my: state.myProposalsIds.length,
        );
      },
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(),
          child: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerHeight: 0,
            tabs: [
              Tab(
                key: const Key('AllProposalsTab'),
                text: context.l10n.noOfAll(state.total),
              ),
              Tab(
                key: const Key('DraftProposalsTab'),
                text: context.l10n.noOfDraft(state.draft),
              ),
              Tab(
                key: const Key('FinalProposalsTab'),
                text: context.l10n.noOfFinal(state.finals),
              ),
              Tab(
                key: const Key('FavoriteProposalsTab'),
                text: context.l10n.noOfFavorites(state.favorites),
              ),
              Tab(
                key: const Key('MyProposalsTab'),
                text: context.l10n.noOfMyProposals(state.my),
              ),
            ],
          ),
        );
      },
    );
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
                _TabBar(),
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
