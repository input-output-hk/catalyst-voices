import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/account/widgets/account_keychain_tile.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/voting/widgets/content/pre_voting_content.dart';
import 'package:catalyst_voices/pages/voting/widgets/content/voting_background.dart';
import 'package:catalyst_voices/pages/voting/widgets/content/voting_content.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_header.dart';
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

class VotingPage extends StatefulWidget {
  final SignedDocumentRef? categoryRef;
  final VotingPageTab? tab;
  final bool keychainDeleted;

  const VotingPage({
    super.key,
    this.categoryRef,
    this.tab,
    this.keychainDeleted = false,
  });

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage>
    with
        TickerProviderStateMixin,
        ErrorHandlerStateMixin<VotingCubit, VotingPage>,
        SignalHandlerStateMixin<VotingCubit, VotingSignal, VotingPage> {
  late VoicesTabController<VotingPageTab> _tabController;
  late final PagingController<ProposalBriefVoting> _pagingController;
  late final StreamSubscription<List<VotingPageTab>> _tabsSubscription;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: CampaignPhaseAware.when(
        phase: CampaignPhaseType.communityVoting,
        upcoming: (_, phase, fundNumber) => HeaderAndContentLayout(
          header: const VotingHeader(),
          content: PreVotingContent(phase: phase, fundNumber: fundNumber),
          background: const VotingBackground(),
          separateHeaderAndContent: false,
        ),
        active: (_, __, ___) => HeaderAndContentLayout(
          header: const VotingHeader(),
          content: VotingContent(
            tabController: _tabController,
            pagingController: _pagingController,
          ),
        ),
        post: (_, __, ___) => HeaderAndContentLayout(
          header: const VotingHeader(),
          content: VotingContent(
            tabController: _tabController,
            pagingController: _pagingController,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(VotingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tab = widget.tab ?? VotingPageTab.total;

    if (widget.categoryRef != oldWidget.categoryRef || widget.tab != oldWidget.tab) {
      context.read<VotingCubit>().changeFilters(
        onlyMy: Optional(tab == VotingPageTab.my),
        category: Optional(widget.categoryRef),
        type: tab.filter,
      );

      _doResetPagination();
    }

    if (widget.tab != oldWidget.tab) {
      _tabController.animateToTab(tab);
    }

    if (showKeychainDeletedDialog) {
      showKeychainDeletedDialog = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    unawaited(_tabsSubscription.cancel());
    super.dispose();
  }

  @override
  void handleSignal(VotingSignal signal) {
    switch (signal) {
      case ChangeCategoryVotingSignal(:final to):
        _updateRoute(categoryId: Optional(to?.id));
      case ChangeTabVotingSignal(:final tab):
        _updateRoute(tab: tab);
      case ResetPaginationVotingSignal():
        _doResetPagination();
      case PageReadyVotingSignal(:final page):
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

    final votingCubit = context.read<VotingCubit>();
    final sessionCubit = context.read<SessionCubit>();
    final supportedTabs = _determineTabs(sessionCubit.state.isProposerUnlock, votingCubit.state);
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
      votingCubit.watchState(),
      _determineTabs,
    ).distinct().listen(_updateTabsIfNeeded);

    votingCubit.init(
      onlyMyProposals: selectedTab == VotingPageTab.my,
      category: widget.categoryRef,
      type: selectedTab.filter,
    );

    _pagingController
      ..addPageRequestListener(_handleProposalsPageRequest)
      ..notifyPageRequestListeners(0);

    // TODO(damian-molinski): same behavior already exists in DiscoveryPage because
    // of way confirmation dialog is shown. Refactor it.
    if (showKeychainDeletedDialog) {
      showKeychainDeletedDialog = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  VotingPageTab _determineTab(
    List<VotingPageTab> supportedTabs,
    VotingPageTab? initialTab,
  ) {
    final requestedTab = initialTab ?? widget.tab ?? supportedTabs.first;
    if (!supportedTabs.contains(requestedTab)) {
      final supportedTab = supportedTabs.first;
      _updateRoute(tab: supportedTab);
      return supportedTab;
    }

    return requestedTab;
  }

  List<VotingPageTab> _determineTabs(bool isProposerUnlock, VotingState state) {
    return state.tabs(isProposerUnlock: isProposerUnlock);
  }

  void _doResetPagination() {
    _pagingController.notifyPageRequestListeners(0);
  }

  Future<void> _handleProposalsPageRequest(
    int pageKey,
    int pageSize,
    ProposalBriefVoting? lastProposalId,
  ) async {
    final request = PageRequest(page: pageKey, size: pageSize);
    await context.read<VotingCubit>().getProposals(request);
  }

  Future<void> _showKeychainDeletedDialog(BuildContext context) async {
    await KeychainDeletedDialog.show(context);
  }

  void _updateRoute({
    Optional<String>? categoryId,
    VotingPageTab? tab,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryRef?.id);
      final effectiveTab = tab?.name ?? widget.tab?.name;

      VotingRoute(
        categoryId: effectiveCategoryId,
        tab: effectiveTab,
      ).replace(context);
    });
  }

  void _updateTabsIfNeeded(List<VotingPageTab> tabs) {
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
