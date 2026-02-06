import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_content.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_header.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/layouts/header_and_content_layout.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProposalsPage extends StatefulWidget {
  final String? categoryId;
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
        TickerProviderStateMixin,
        ErrorHandlerStateMixin<ProposalsCubit, ProposalsPage>,
        SignalHandlerStateMixin<ProposalsCubit, ProposalsSignal, ProposalsPage> {
  late final _cubit = Dependencies.instance.get<ProposalsCubit>();
  late VoicesTabController<ProposalsPageTab> _tabController;
  late final PagingController<ProposalBrief> _pagingController;
  late final StreamSubscription<List<ProposalsPageTab>> _tabsSubscription;

  @override
  ProposalsCubit get errorEmitter => _cubit;

  @override
  ProposalsCubit get signalEmitter => _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: ProposalSubmissionPhaseAware(
        activeChild: HeaderAndContentLayout(
          header: const ProposalsHeader(),
          content: ProposalsContent(
            tabController: _tabController,
            pagingController: _pagingController,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(ProposalsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tab = widget.tab ?? ProposalsPageTab.total;

    if (widget.categoryId != oldWidget.categoryId || widget.tab != oldWidget.tab) {
      _cubit.changeFilters(
        categoryId: Optional(widget.categoryId),
        tab: Optional(tab),
      );

      _doResetPagination();
    }

    if (widget.tab != oldWidget.tab) {
      _tabController.animateToTab(tab);
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    _tabController.dispose();
    _pagingController.dispose();
    unawaited(_tabsSubscription.cancel());
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

    final sessionCubit = context.read<SessionCubit>();
    final supportedTabs = _determineTabs(sessionCubit.state.isProposerUnlock, _cubit.state);
    final selectedTab = _determineTab(supportedTabs, widget.tab);

    _tabController = VoicesTabController(
      initialTab: selectedTab,
      tabs: supportedTabs,
      vsync: this,
    );

    _pagingController = PagingController(
      initialPage: 0,
      initialMaxResults: 0,
    );

    _tabsSubscription = Rx.combineLatest2(
      sessionCubit.watchState().map((e) => e.isProposerUnlock),
      _cubit.watchState(),
      _determineTabs,
    ).distinct().listen(_updateTabsIfNeeded);

    unawaited(
      _cubit.init(
        categoryId: widget.categoryId,
        tab: widget.tab ?? ProposalsPageTab.total,
      ),
    );

    _pagingController
      ..addPageRequestListener(_handleProposalsPageRequest)
      ..notifyPageRequestListeners(0);
  }

  ProposalsPageTab _determineTab(
    List<ProposalsPageTab> supportedTabs,
    ProposalsPageTab? initialTab,
  ) {
    final requestedTab = initialTab ?? widget.tab ?? supportedTabs.first;
    if (!supportedTabs.contains(requestedTab)) {
      final supportedTab = supportedTabs.first;
      _updateRoute(tab: supportedTab);
      return supportedTab;
    }

    return requestedTab;
  }

  List<ProposalsPageTab> _determineTabs(bool isProposerUnlock, ProposalsState state) {
    return state.tabs(isProposerUnlock: isProposerUnlock);
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
    await _cubit.getProposals(request);
  }

  void _updateRoute({
    Optional<String>? categoryId,
    ProposalsPageTab? tab,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryId);
      final effectiveTab = tab?.name ?? widget.tab?.name;

      ProposalsRoute(
        categoryId: effectiveCategoryId,
        tab: effectiveTab,
      ).replace(context);
    });
  }

  void _updateTabsIfNeeded(List<ProposalsPageTab> tabs) {
    if (!listEquals(tabs, _tabController.tabs)) {
      setState(() {
        _tabController.dispose();
        _tabController = VoicesTabController(
          vsync: this,
          tabs: tabs,
          initialTab: _determineTab(tabs, _tabController.tab),
        );
      });
    }
  }
}
