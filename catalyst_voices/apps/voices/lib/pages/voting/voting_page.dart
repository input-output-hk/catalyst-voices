import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/voting/widgets/pre_voting_content.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_background.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_content.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_header.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/layouts/header_and_content_layout.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingPage extends StatefulWidget {
  final SignedDocumentRef? categoryId;
  final ProposalsFilterType? type;

  const VotingPage({
    super.key,
    this.categoryId,
    this.type,
  });

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage>
    with
        SingleTickerProviderStateMixin,
        ErrorHandlerStateMixin<VotingCubit, VotingPage>,
        SignalHandlerStateMixin<VotingCubit, VotingSignal, VotingPage> {
  late final TabController _tabController;
  late final PagingController<ProposalBrief> _pagingController;

  @override
  Widget build(BuildContext context) {
    return CampaignPhaseAware.when(
      phase: CampaignPhaseType.communityVoting,
      upcoming: (_, phase, fundNumber) => HeaderAndContentLayout(
        header: const VotingHeader(),
        content: PreVotingContent(phase: phase, fundNumber: fundNumber),
        background: const VotingBackground(),
      ),
      active: (_, __, ___) => const HeaderAndContentLayout(
        header: VotingHeader(),
        content: VotingContent(),
      ),
      post: (_, __, ___) => const HeaderAndContentLayout(
        header: VotingHeader(),
        content: Text('Post'),
      ),
    );
  }

  @override
  void didUpdateWidget(VotingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoryId != oldWidget.categoryId || widget.type != oldWidget.type) {
      context.read<VotingCubit>().changeFilters(
            onlyMy: Optional(widget.type?.isMy ?? false),
            category: Optional(widget.categoryId),
            type: widget.type ?? ProposalsFilterType.total,
          );

      _doResetPagination();
    }

    if (widget.type != oldWidget.type) {
      _tabController.animateTo(widget.type?.index ?? 0);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void handleSignal(VotingSignal signal) {
    switch (signal) {
      case ChangeCategoryVotingSignal(:final to):
        _updateRoute(categoryId: Optional(to?.id));
      case ChangeFilterTypeVotingSignal(:final type):
        _updateRoute(filterType: type);
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

    final proposalsFilterType = _determineFilterType();

    _tabController = TabController(
      initialIndex: proposalsFilterType.index,
      length: ProposalsFilterType.values.length,
      vsync: this,
    );

    _pagingController = PagingController(
      initialPage: 0,
      initialMaxResults: 0,
    );

    context.read<VotingCubit>().init(
          onlyMyProposals: widget.type?.isMy ?? false,
          category: widget.categoryId,
          type: proposalsFilterType,
          order: const Alphabetical(),
        );

    _pagingController
      ..addPageRequestListener(_handleProposalsPageRequest)
      ..notifyPageRequestListeners(0);
  }

  ProposalsFilterType _determineFilterType() {
    final isProposerUnlock = context.read<SessionCubit>().state.isProposerUnlock;
    final requestedType = widget.type;

    if (!isProposerUnlock && (requestedType?.isMy ?? false)) {
      _updateRoute(filterType: ProposalsFilterType.total);
    }

    return requestedType ?? ProposalsFilterType.total;
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
    await context.read<VotingCubit>().getProposals(request);
  }

  void _updateRoute({
    Optional<String>? categoryId,
    ProposalsFilterType? filterType,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryId?.id);
      final effectiveType = filterType?.name ?? widget.type?.name;

      VotingRoute(
        categoryId: effectiveCategoryId,
        type: effectiveType,
      ).replace(context);
    });
  }
}
