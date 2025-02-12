import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/widgets/cards/campaign_stage_card.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/pagination/builders/paged_wrap_child_builder.dart';
import 'package:catalyst_voices/widgets/pagination/layouts/paginated_grid_view.dart.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    unawaited(context.read<CampaignInfoCubit>().load());
    unawaited(context.read<ProposalsCubit>().load());
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
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _FundInfo()),
            Expanded(child: _CampaignStage()),
          ],
        ),
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
        children: [
          Text(
            context.l10n.discoverySpaceTitle,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.discoverySpaceDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const _CampaignDetailsButton(),
        ],
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

class _CampaignStage extends StatelessWidget {
  const _CampaignStage();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: BlocBuilder<CampaignInfoCubit, CampaignInfoState>(
          builder: (context, state) {
            final campaign = state.campaign;
            return campaign != null
                ? CampaignStageCard(campaign: campaign)
                : const Offstage();
          },
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
  late final TabController _tabController;
  final tabsLength = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabsLength, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<ProposalsCubit>().resetCurrentPage();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsLength,
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
                _TabBar(_tabController),
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
            controller: _tabController,
            children: [
              BlocBuilder<ProposalsCubit, ProposalsState>(
                buildWhen: (previous, current) {
                  if (previous.proposals.proposals !=
                      current.proposals.proposals) {
                    return true;
                  } else if (previous.pageKey != current.pageKey) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return _AllProposals(
                    state.proposals.proposals,
                    state.pageKey,
                    state.proposals.totalProposalCount,
                  );
                },
              ),
              BlocBuilder<ProposalsCubit, ProposalsState>(
                buildWhen: (previous, current) {
                  if (previous.proposals.proposals.draftProposals !=
                      current.proposals.proposals.draftProposals) {
                    return true;
                  } else if (previous.pageKey != current.pageKey) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return _AllProposals(
                    state.proposals.proposals.draftProposals,
                    state.pageKey,
                    state.proposals.draftProposalCount,
                  );
                },
              ),
              BlocBuilder<ProposalsCubit, ProposalsState>(
                buildWhen: (previous, current) {
                  if (previous.proposals.proposals.finalProposals !=
                      current.proposals.proposals.finalProposals) {
                    return true;
                  } else if (previous.pageKey != current.pageKey) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return _AllProposals(
                    state.proposals.proposals.finalProposals,
                    state.pageKey,
                    state.proposals.finalProposalCount,
                  );
                },
              ),
              // const _DraftProposals(),
              const _FinalProposals(),
              const _FavoriteProposals(),
              // const _FavoriteProposals(),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final TabController tabController;
  const _TabBar(this.tabController);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState,
        ProposalSearchViewModel>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerHeight: 0,
            tabs: [
              Tab(
                text: context.l10n.noOfAll(state.totalProposalCount),
              ),
              Tab(
                text: context.l10n.noOfDraft(state.draftProposalCount),
              ),
              Tab(
                text: context.l10n.noOfFinal(state.finalProposalCount),
              ),
              Tab(
                text: context.l10n.noOfFavorites(state.favoriteProposalCount),
              ),
              Tab(
                text: context.l10n.noOfMyProposals(100),
              ),
            ],
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
          const FilterByDropdown(
            items: [],
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 250,
            child: VoicesTextField(
              onFieldSubmitted: (_) {},
              decoration: VoicesTextFieldDecoration(
                prefixIcon: VoicesAssets.icons.search.buildIcon(),
                hintText: context.l10n.searchProposals,
                filled: true,
                fillColor: context.colors.elevationsOnSurfaceNeutralLv1White,
                suffixIcon: Offstage(
                  offstage: false,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(context.l10n.clear),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllProposals extends StatefulWidget {
  final List<ProposalViewModel> proposals;
  final int pageKey;
  final int maxResults;
  const _AllProposals(
    this.proposals,
    this.pageKey,
    this.maxResults,
  );

  @override
  State<_AllProposals> createState() => _AllProposalsState();
}

class _AllProposalsState extends State<_AllProposals> {
  late final ProposalsCubit _proposalBloc;
  late PagingController<ProposalViewModel> _pagingController;

  @override
  void initState() {
    super.initState();
    _proposalBloc = context.read<ProposalsCubit>();
    _pagingController = PagingController(
      initialPage: widget.pageKey,
      initialMaxResults: widget.maxResults,
      itemsPerPage: 8,
    );

    _pagingController.addPageRequestListener((
      newPageKey,
      pageSize,
      lastItem,
    ) async {
      await _proposalBloc.load(
        pageKey: newPageKey,
        pageSize: pageSize,
        lastProposalId: lastItem?.id,
      );
    });
    _handleItemListChange();
  }

  @override
  void didUpdateWidget(covariant _AllProposals oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageKey != widget.pageKey) {
      _pagingController.currentPage = widget.pageKey;
    }
    if (oldWidget.maxResults != widget.maxResults) {
      _pagingController.maxResults = widget.maxResults;
    }
    if (oldWidget.proposals != widget.proposals) {
      _handleItemListChange();
    }
  }

  void _handleItemListChange() {
    _pagingController.appendPage(
      widget.proposals,
      widget.pageKey,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    // unawaited(_blocSub.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedGridView<ProposalViewModel>(
      pagingController: _pagingController,
      builderDelegate: PagedWrapChildBuilder<ProposalViewModel>(
        builder: (context, item) => ProposalCard(
          key: UniqueKey(),
          proposal: item,
          showStatus: false,
          showLastUpdate: false,
          showComments: false,
          showSegments: false,
          isFavorite: item.isFavorite,
          onFavoriteChanged: (isFavorite) async {
            await context.read<ProposalsCubit>().onChangeFavoriteProposal(
                  item.id,
                  isFavorite: isFavorite,
                );
          },
        ),
        emptyIndicatorBuilder: (context) => const _EmptyProposals(),
        animateTransition: false,
      ),
    );
  }
}

class _DraftProposals extends StatefulWidget {
  const _DraftProposals();

  @override
  State<_DraftProposals> createState() => _DraftProposalsState();
}

class _DraftProposalsState extends State<_DraftProposals> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsCubit, ProposalsState>(
      builder: (context, state) {
        return const Placeholder();
      },
    );
  }
}

class _FinalProposals extends StatefulWidget {
  const _FinalProposals();

  @override
  State<_FinalProposals> createState() => _FinalProposalsState();
}

class _FinalProposalsState extends State<_FinalProposals> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsCubit, ProposalsState>(
      builder: (context, state) {
        return const Placeholder();
      },
    );
  }
}

class _FavoriteProposals extends StatelessWidget {
  const _FavoriteProposals();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsCubit, ProposalsState>(
      builder: (context, state) {
        return const Placeholder();
      },
    );
  }
}

class _ProposalsList extends StatelessWidget {
  final List<ProposalViewModel> proposals;

  const _ProposalsList({
    required this.proposals,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final proposal in proposals)
          ProposalCard(
            key: UniqueKey(),
            image: _generateImageForProposal(proposal.id),
            proposal: proposal,
            showStatus: false,
            showLastUpdate: false,
            showComments: false,
            showSegments: false,
            isFavorite: proposal.isFavorite,
            onFavoriteChanged: (isFavorite) async {
              await context.read<ProposalsCubit>().onChangeFavoriteProposal(
                    proposal.id,
                    isFavorite: isFavorite,
                  );
            },
          ),
      ],
    );
  }
}

class _LoadingProposals extends StatelessWidget {
  const _LoadingProposals();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(64),
        child: VoicesCircularProgressIndicator(),
      ),
    );
  }
}

class _EmptyProposals extends StatelessWidget {
  const _EmptyProposals();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyState(
        description: context.l10n.discoverySpaceEmptyProposals,
      ),
    );
  }
}

AssetGenImage _generateImageForProposal(String id) {
  return id.codeUnits.last.isEven
      ? VoicesAssets.images.proposalBackground1
      : VoicesAssets.images.proposalBackground2;
}
