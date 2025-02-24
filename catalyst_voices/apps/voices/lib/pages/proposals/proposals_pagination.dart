import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/pagination/builders/paged_wrap_child_builder.dart';
import 'package:catalyst_voices/widgets/pagination/layouts/paginated_grid_view.dart.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsPagination extends StatefulWidget {
  final List<ProposalViewModel> proposals;
  final int pageKey;
  final int maxResults;
  final ProposalPublish? stage;
  final bool isEmpty;
  final bool userProposals;
  final bool usersFavorite;
  final String? categoryId;

  const ProposalsPagination(
    this.proposals,
    this.pageKey,
    this.maxResults, {
    super.key,
    this.stage,
    this.isEmpty = false,
    this.userProposals = false,
    this.usersFavorite = false,
    this.categoryId,
  });

  @override
  State<ProposalsPagination> createState() => _ProposalsPaginationState();
}

class _ProposalsPaginationState extends State<ProposalsPagination> {
  late final ProposalsCubit _proposalBloc;
  late PagingController<ProposalViewModel> _pagingController;

  @override
  void initState() {
    super.initState();
    _proposalBloc = context.read<ProposalsCubit>();
    _pagingController = PagingController(
      initialPage: widget.pageKey,
      initialMaxResults: widget.maxResults,
    );

    _pagingController.addPageRequestListener((
      newPageKey,
      pageSize,
      lastItem,
    ) async {
      final request = ProposalPaginationRequest(
        pageKey: newPageKey,
        pageSize: pageSize,
        lastId: lastItem?.id,
        stage: widget.stage,
        categoryId: widget.categoryId,
        usersProposals: widget.userProposals,
        usersFavorite: widget.usersFavorite,
      );
      await _proposalBloc.getProposals(request);
    });
    _handleItemListChange();
    _pagingController.notifyPageRequestListeners(0);
  }

  @override
  void didUpdateWidget(covariant ProposalsPagination oldWidget) {
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
    if (oldWidget.categoryId != widget.categoryId) {
      _pagingController.notifyPageRequestListeners(0);
    }
    if (widget.isEmpty != oldWidget.isEmpty ||
        (oldWidget.isEmpty && widget.isEmpty)) {
      _pagingController.empty();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedGridView<ProposalViewModel>(
      pagingController: _pagingController,
      builderDelegate: PagedWrapChildBuilder<ProposalViewModel>(
        builder: (context, item) => ProposalCard(
          key: ValueKey(item.id),
          proposal: item,
          showStatus: false,
          showLastUpdate: false,
          showComments: false,
          showSegments: false,
          isFavorite: item.isFavorite,
          onTap: () {
            final route = ProposalRoute(
              proposalId: item.id,
              draft: item.isDraft,
            );

            unawaited(route.push(context));
          },
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

  void _handleItemListChange() {
    _pagingController.appendPage(
      widget.proposals,
      widget.pageKey,
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
