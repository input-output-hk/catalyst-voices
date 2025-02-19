import 'package:catalyst_voices/widgets/pagination/builders/paged_wrap_child_builder.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices/widgets/pagination/paging_state.dart';
import 'package:catalyst_voices/widgets/pagination/paging_status.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class PaginatedGridView<ItemType> extends StatelessWidget {
  final PagingController<ItemType> pagingController;
  final PagedWrapChildBuilder<ItemType> builderDelegate;

  const PaginatedGridView({
    super.key,
    required this.pagingController,
    required this.builderDelegate,
  });

  WidgetBuilder get _errorIndicatorBuilder =>
      builderDelegate.errorIndicatorBuilder ??
      (context) => VoicesErrorIndicator(
            message: context.l10n.somethingWentWrong,
          );

  ItemWidgetBuilder<ItemType> get _itemBuilder => builderDelegate.builder;

  WidgetBuilder get _loadingIndicatorBuilder =>
      builderDelegate.loadingIndicatorBuilder ??
      (_) => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: VoicesCircularProgressIndicator()),
          );

  PagingController<ItemType> get _pagingController => pagingController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PagingState<ItemType>>(
      valueListenable: _pagingController,
      builder: (context, pagingState, _) {
        Widget child;
        final itemList = _pagingController.itemList;
        switch (pagingState.status) {
          case PagingStatus.empty:
            child = builderDelegate.emptyIndicatorBuilder(context);
            break;
          case PagingStatus.loading:
            child = _loadingIndicatorBuilder(context);
            break;

          case PagingStatus.ongoing:
          case PagingStatus.completed:
            child = SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (var i = pagingState.currentFrom;
                      i <= pagingState.currentTo;
                      i++)
                    _itemBuilder(
                      context,
                      itemList[i],
                    ),
                ],
              ),
            );
            break;

          case PagingStatus.error:
            child = _errorIndicatorBuilder(context);
            break;
        }

        if (builderDelegate.animateTransition) {
          child = AnimatedSwitcher(
            duration: builderDelegate.transitionDuration,
            child: child,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            Offstage(
              offstage: pagingState.itemList.isEmpty,
              child: _Controls(
                fromNumber: pagingState.fromValue,
                toNumber: pagingState.toValue,
                maxResults: pagingState.maxResults,
                onNextPageTap: pagingState.isLastPage
                    ? null
                    : () => _onNextPageTap(pagingState),
                onPrevPageTap: pagingState.isFirstPage ? null : _onPrevPageTap,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onNextPageTap(PagingState<ItemType> pagingState) {
    if (pagingState.isLoading) return;
    if (pagingState.currentPage < pagingState.currentLastPage) {
      _pagingController.nextPage();
    } else {
      _pagingController
          .notifyPageRequestListeners(_pagingController.nextPageValue);
    }
  }

  void _onPrevPageTap() {
    _pagingController.prevPage();
  }
}

class _Controls extends StatelessWidget {
  final int fromNumber;
  final int toNumber;
  final int maxResults;
  final VoidCallback? onNextPageTap;
  final VoidCallback? onPrevPageTap;

  const _Controls({
    required this.fromNumber,
    required this.toNumber,
    required this.maxResults,
    this.onNextPageTap,
    this.onPrevPageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$fromNumber-$toNumber of $maxResults proposals',
        ),
        VoicesIconButton(
          onTap: onPrevPageTap,
          child: VoicesAssets.icons.chevronLeft.buildIcon(),
        ),
        VoicesIconButton(
          onTap: onNextPageTap,
          child: VoicesAssets.icons.chevronRight.buildIcon(),
        ),
      ],
    );
  }
}
