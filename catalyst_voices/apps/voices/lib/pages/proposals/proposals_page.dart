import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_content.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_header.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/layouts/header_and_content_layout.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsPage extends StatefulWidget {
  final SignedDocumentRef? categoryId;
  final ProposalsPageTab? tab;

  const ProposalsPage({
    super.key,
    this.categoryId,
    this.tab,
  });

  @override
  State<ProposalsPage> createState() => _ProposalsPageState();
}

class _ProposalsPageState extends State<ProposalsPage>
    with
        SingleTickerProviderStateMixin,
        ErrorHandlerStateMixin<ProposalsCubit, ProposalsPage>,
        SignalHandlerStateMixin<ProposalsCubit, ProposalsSignal, ProposalsPage> {
  late final TabController _tabController;
  late final PagingController<ProposalBrief> _pagingController;

  @override
  Widget build(BuildContext context) {
    return ProposalSubmissionPhaseAware(
      activeChild: HeaderAndContentLayout(
        header: const ProposalsHeader(),
        content: ProposalsContent(
          tabController: _tabController,
          pagingController: _pagingController,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(ProposalsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tab = widget.tab ?? ProposalsPageTab.total;

    if (widget.categoryId != oldWidget.categoryId || widget.tab != oldWidget.tab) {
      context.read<ProposalsCubit>().changeFilters(
        onlyMy: Optional(tab == ProposalsPageTab.my),
        category: Optional(widget.categoryId),
        type: tab.filter,
      );

      _doResetPagination();
    }

    if (widget.tab != oldWidget.tab) {
      _tabController.animateTo(tab.index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void handleSignal(ProposalsSignal signal) {
    switch (signal) {
      case ChangeCategoryProposalsSignal(:final to):
        _updateRoute(categoryId: Optional(to?.id));
      case ChangeTabProposalsSignal(:final tab):
        _updateRoute(tab: tab);
      case ResetPaginationProposalsSignal():
        _doResetPagination();
      case PageReadyProposalsSignal(:final page):
        _pagingController.value = _pagingController.value.copyWith(
          currentPage: page.page,
          maxResults: page.total,
          itemList: page.items,
          error: const Optional.empty(),
          isLoading: false,
        );
    }
  }

  @override
  void initState() {
    super.initState();

    final tab = _determineTab();

    _tabController = TabController(
      initialIndex: tab.index,
      length: ProposalsPageTab.values.length,
      vsync: this,
    );

    _pagingController = PagingController(
      initialPage: 0,
      initialMaxResults: 0,
    );

    context.read<ProposalsCubit>().init(
      onlyMyProposals: tab == ProposalsPageTab.my,
      category: widget.categoryId,
      type: tab.filter,
      order: const Alphabetical(),
    );

    _pagingController
      ..addPageRequestListener(_handleProposalsPageRequest)
      ..notifyPageRequestListeners(0);
  }

  ProposalsPageTab _determineTab() {
    final isProposerUnlock = context.read<SessionCubit>().state.isProposerUnlock;
    final requestedTab = widget.tab ?? ProposalsPageTab.total;

    if (!isProposerUnlock && requestedTab == ProposalsPageTab.my) {
      _updateRoute(tab: ProposalsPageTab.total);
      return ProposalsPageTab.total;
    }

    return requestedTab;
  }

  void _doResetPagination() {
    _pagingController.notifyPageRequestListeners(0);
  }

  Future<void> _handleProposalsPageRequest(
    int pageKey,
    int pageSize,
    ProposalBrief? lastProposalId,
  ) async {
    final request = PageRequest(page: pageKey, size: pageSize);
    await context.read<ProposalsCubit>().getProposals(request);
  }

  void _updateRoute({
    Optional<String>? categoryId,
    ProposalsPageTab? tab,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryId?.id);
      final effectiveTab = tab?.name ?? widget.tab?.name;

      ProposalsRoute(
        categoryId: effectiveCategoryId,
        tab: effectiveTab,
      ).replace(context);
    });
  }
}
