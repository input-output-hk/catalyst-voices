import 'dart:async';

import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_controls.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_header.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_pagination.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs_divider.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
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
  late final PagingController<ProposalViewModel> _pagingController;

  StreamSubscription<ProposalPaginationItems<ProposalViewModel>>? _proposalsSub;

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
                    const SizedBox(height: 24),
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

    if (widget.categoryId != oldWidget.categoryId ||
        widget.selectMyProposalsView != oldWidget.selectMyProposalsView ||
        widget.type != oldWidget.type) {
      context.read<ProposalsCubit>().changeFilters(
            onlyMy: widget.selectMyProposalsView,
            category: widget.categoryId,
            type: widget.type ?? ProposalsFilterType.total,
          );

      // Reset pagination.
      _pagingController.notifyPageRequestListeners(0);
    }

    if (widget.type != oldWidget.type) {
      _tabController.animateTo(widget.type?.index ?? 0);
    }
  }

  @override
  void dispose() {
    unawaited(_proposalsSub?.cancel());
    _proposalsSub = null;

    _tabController.dispose();
    _pagingController.dispose();
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
    _pagingController = PagingController(
      initialPage: 0,
      initialMaxResults: 0,
    );

    final cubit = context.read<ProposalsCubit>()
      ..init(
        onlyMyProposals: widget.selectMyProposalsView,
        category: widget.categoryId,
        type: proposalsFilterType,
      );

    _proposalsSub = cubit.stream
        .map((event) => event.proposals)
        .distinct()
        .listen(_handleProposalsChange);

    _pagingController
      ..addPageRequestListener(_handleProposalsPageRequest)
      ..notifyPageRequestListeners(0);
  }

  void _handleProposalsChange(ProposalPaginationItems<ProposalViewModel> data) {
    _pagingController.value = _pagingController.value.copyWith(
      currentPage: data.pageKey,
      maxResults: data.maxResults,
      itemList: data.items,
      isLoading: data.isLoading,
    );
  }

  Future<void> _handleProposalsPageRequest(
    int pageKey,
    int pageSize,
    ProposalViewModel? lastProposalId,
  ) async {
    final request = PaginationPage<String?>(
      pageKey: pageKey,
      pageSize: pageSize,
      lastId: lastProposalId?.ref.id,
    );
    await context.read<ProposalsCubit>().getProposals(request);
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
