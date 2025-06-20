import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_controls.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_header.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_pagination.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_sub_header.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs_divider.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsPage extends StatefulWidget {
  final SignedDocumentRef? categoryId;
  final ProposalsFilterType? type;

  const ProposalsPage({
    super.key,
    this.categoryId,
    this.type,
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
  late final PagingController<ProposalViewModel> _pagingController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding:
              const EdgeInsets.symmetric(horizontal: 32).add(const EdgeInsets.only(bottom: 32)),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 16),
                const ProposalsHeader(),
                const SizedBox(height: 40),
                Column(
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
                          ProposalsTabs(controller: _tabController),
                          const ProposalsControls(),
                        ],
                      ),
                    ),
                    const ProposalsTabsDivider(),
                    const SizedBox(height: 16),
                    const ProposalsSubHeader(),
                    const SizedBox(height: 16),
                    ProposalsPagination(controller: _pagingController),
                    const SizedBox(height: 12),
                  ],
                ),
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

    if (widget.categoryId != oldWidget.categoryId || widget.type != oldWidget.type) {
      context.read<ProposalsCubit>().changeFilters(
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
  void handleSignal(ProposalsSignal signal) {
    switch (signal) {
      case ChangeCategorySignal(:final to):
        _updateRoute(categoryId: Optional(to?.id));
      case ChangeFilterTypeSignal(:final type):
        _updateRoute(filterType: type);
      case ResetProposalsPaginationSignal():
        _doResetPagination();
      case ProposalsPageReadySignal(:final page):
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

    context.read<ProposalsCubit>().init(
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
    ProposalViewModel? lastProposalId,
  ) async {
    final request = PageRequest(page: pageKey, size: pageSize);
    await context.read<ProposalsCubit>().getProposals(request);
  }

  void _updateRoute({
    Optional<String>? categoryId,
    ProposalsFilterType? filterType,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryId?.id);
      final effectiveType = filterType?.name ?? widget.type?.name;

      ProposalsRoute(
        categoryId: effectiveCategoryId,
        type: effectiveType,
      ).replace(context);
    });
  }
}
