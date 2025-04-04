import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/proposals/proposal_pagination_tabview.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_controls.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_header.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
                const ProposalsHeader(),
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
              const ProposalsControls(),
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
