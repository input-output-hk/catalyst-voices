import 'package:catalyst_voices/common/ext/ext.dart';
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
  final bool userProposals;
  final bool usersFavorite;
  final String? categoryId;
  final String? searchValue;
  final bool isLoading;

  const ProposalsPagination(
    this.proposals,
    this.pageKey,
    this.maxResults, {
    super.key,
    this.stage,
    this.userProposals = false,
    this.usersFavorite = false,
    this.categoryId,
    this.searchValue,
    required this.isLoading,
  });

  @override
  State<ProposalsPagination> createState() => ProposalsPaginationState();
}

class ProposalsPaginationState extends State<ProposalsPagination> {
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
  void didUpdateWidget(ProposalsPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      _pagingController.isLoading = widget.isLoading;
    }
    if (oldWidget.pageKey != widget.pageKey) {
      _pagingController.currentPage = widget.pageKey;
    }
    if (oldWidget.maxResults != widget.maxResults) {
      _pagingController.maxResults = widget.maxResults;
    }
    if (oldWidget.proposals != widget.proposals) {
      _handleItemListChange();
    }

    if (oldWidget.categoryId != widget.categoryId ||
        oldWidget.searchValue != widget.searchValue) {
      _pagingController.notifyPageRequestListeners(0);
    }

    if (oldWidget.isLoading != widget.isLoading) {
      _pagingController.isLoading = widget.isLoading;
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
        builder: (context, item) =>
            BlocSelector<ProposalsCubit, ProposalsState, bool>(
          selector: (state) {
            return state.isFavorite(item.id);
          },
          builder: (context, state) {
            return ProposalCard(
              key: ValueKey(item.id),
              proposal: item,
              isFavorite: widget.usersFavorite ? item.isFavorite : state,
              onFavoriteChanged: (isFavorite) async {
                await context.read<ProposalsCubit>().onChangeFavoriteProposal(
                      item.id,
                      isFavorite: isFavorite,
                    );
              },
            );
          },
        ),
        emptyIndicatorBuilder: (context) =>
            BlocSelector<ProposalsCubit, ProposalsState, bool>(
          selector: (state) {
            return state.searchValue?.isNotEmpty ?? false;
          },
          builder: (context, state) {
            if (state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.searchResult,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colors.textOnPrimaryLevel1,
                    ),
                  ),
                  _EmptyProposals(
                    title: context.l10n.emptySearchResultTitle,
                    description: context.l10n.tryDifferentSearch,
                  ),
                ],
              );
            }
            return const _EmptyProposals();
          },
        ),
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
  final String? title;
  final String? description;
  const _EmptyProposals({
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyState(
        title: title,
        description: description ?? context.l10n.discoverySpaceEmptyProposals,
      ),
    );
  }
}
