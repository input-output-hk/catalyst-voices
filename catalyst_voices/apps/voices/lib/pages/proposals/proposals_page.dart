import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/pages/proposals/proposals_pagination.dart';
import 'package:catalyst_voices/pages/proposals/search_input_field.dart';
import 'package:catalyst_voices/widgets/dropdown/category_dropdown.dart';
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

typedef _ProposalsTabSelector = ({
  ProposalPaginationItems<ProposalViewModel> items,
  String? selectedCategoryId,
  String? searchValue,
});

typedef _FavoritesTabSelector = ({
  ProposalPaginationItems<ProposalViewModel> items,
  String? selectedCategoryId,
  bool shouldReload,
});

class ProposalsPage extends StatefulWidget {
  final String? categoryId;

  const ProposalsPage({
    super.key,
    this.categoryId,
  });

  @override
  State<ProposalsPage> createState() => _ProposalsPageState();
}

class _ProposalsPageState extends State<ProposalsPage> {
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

  @override
  void didUpdateWidget(ProposalsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      context.read<ProposalsCubit>().changeSelectedCategory(widget.categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _ActiveAccountBody(),
      ],
    );
  }
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
            context.l10n.catalystF14,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.currentCampaignDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const _CampaignDetailsButton(),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChangeCategoryButtonSelector(),
          SizedBox(width: 8),
          SearchInputField(),
        ],
      ),
    );
  }
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
  });

  @override
  State<_ChangeCategoryButton> createState() => _ChangeCategoryButtonState();
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
              context.l10n.category,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textDisabled,
              ),
            ),
            const SizedBox(width: 4),
            Text(
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

class _Tabs extends StatefulWidget {
  const _Tabs();

  @override
  State<_Tabs> createState() => _TabsState();
}

class _TabsState extends State<_Tabs> with TickerProviderStateMixin {
  late final TabController _controller =
      TabController(length: _tabLength, vsync: this);
  final _tabLength = 5;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabLength,
      child: Column(
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
                _TabBar(_controller),
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
            controller: _controller,
            children: [
              BlocSelector<ProposalsCubit, ProposalsState,
                  _ProposalsTabSelector>(
                selector: (state) {
                  return (
                    items: state.allProposals,
                    selectedCategoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalsPagination(
                    state.items.items,
                    state.items.pageKey,
                    state.items.maxResults,
                    isEmpty: state.items.isEmpty,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
              ),
              BlocSelector<ProposalsCubit, ProposalsState,
                  _ProposalsTabSelector>(
                selector: (state) {
                  return (
                    items: state.draftProposals,
                    selectedCategoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalsPagination(
                    state.items.items,
                    state.items.pageKey,
                    state.items.maxResults,
                    isEmpty: state.items.isEmpty,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                    stage: ProposalPublish.draft,
                  );
                },
              ),
              BlocSelector<ProposalsCubit, ProposalsState,
                  _ProposalsTabSelector>(
                selector: (state) {
                  return (
                    items: state.finalProposals,
                    selectedCategoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalsPagination(
                    state.items.items,
                    state.items.pageKey,
                    state.items.maxResults,
                    isEmpty: state.items.isEmpty,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                    stage: ProposalPublish.published,
                  );
                },
              ),
              _FavoritesProposals(_controller),
              BlocSelector<ProposalsCubit, ProposalsState,
                  _ProposalsTabSelector>(
                selector: (state) {
                  return (
                    items: state.userProposals,
                    selectedCategoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
                  );
                },
                builder: (context, state) {
                  return ProposalsPagination(
                    state.items.items,
                    state.items.pageKey,
                    state.items.maxResults,
                    isEmpty: state.items.isEmpty,
                    categoryId: state.selectedCategoryId,
                    searchValue: state.searchValue,
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

class _FavoritesProposals extends StatefulWidget {
  final TabController controller;

  const _FavoritesProposals(
    this.controller,
  );

  @override
  State<_FavoritesProposals> createState() => _FavoritesProposalsState();
}

class _FavoritesProposalsState extends State<_FavoritesProposals> {
  bool isTabSelected = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSelectionChange);
  }

  @override
  void didUpdateWidget(_FavoritesProposals oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller.removeListener(_onSelectionChange);
      widget.controller.addListener(_onSelectionChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, _FavoritesTabSelector>(
      selector: (state) {
        final items = state.favoriteProposals;
        final shouldReload = state.favoritesIds.length != items.items.length;
        return (
          items: items,
          selectedCategoryId: state.selectedCategoryId,
          shouldReload: shouldReload,
        );
      },
      builder: (context, state) {
        return ProposalsPagination(
          state.items.items,
          state.items.pageKey,
          state.items.maxResults,
          isEmpty: state.items.items.isEmpty,
          categoryId: state.selectedCategoryId,
          usersFavorite: true,
          shouldReload: state.shouldReload && isTabSelected,
        );
      },
    );
  }

  void _onSelectionChange() {
    if (!widget.controller.indexIsChanging) {
      setState(() {
        isTabSelected = widget.controller.index == 3;
      });
    }
  }
}

class _TabBar extends StatelessWidget {
  final TabController controller;

  const _TabBar(this.controller);

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
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerHeight: 0,
            tabs: [
              Tab(
                text: context.l10n.noOfAll(state.total),
              ),
              Tab(
                text: context.l10n.noOfDraft(state.draft),
              ),
              Tab(
                text: context.l10n.noOfFinal(state.finals),
              ),
              Tab(
                text: context.l10n.noOfFavorites(state.favorites),
              ),
              Tab(
                text: context.l10n.noOfMyProposals(state.my),
              ),
            ],
          ),
        );
      },
    );
  }
}
