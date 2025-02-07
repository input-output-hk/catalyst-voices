import 'package:catalyst_voices/widgets/pagination/builders/paged_wrap_child_builder.dart';
import 'package:catalyst_voices/widgets/pagination/listenable_listener.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices/widgets/pagination/paging_state.dart';
import 'package:catalyst_voices/widgets/pagination/paging_status.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class GridWrapLayout<ItemType> extends StatefulWidget {
  final PagingController<ItemType> pagingController;
  final PagedWrapChildBuilder<ItemType> builderDelegate;

  const GridWrapLayout({
    super.key,
    required this.pagingController,
    required this.builderDelegate,
  });

  @override
  State<GridWrapLayout<ItemType>> createState() =>
      _GridWrapLayoutState<ItemType>();
}

class _GridWrapLayoutState<ItemType> extends State<GridWrapLayout<ItemType>> {
  PagingController<ItemType> get _pagingController => widget.pagingController;

  ItemWidgetBuilder<ItemType> get _itemBuilder =>
      widget.builderDelegate.builder;

  WidgetBuilder get _errorIndicatorBuilder =>
      widget.builderDelegate.errorIndicatorBuilder ??
      (_) => VoicesErrorIndicator(
            message: context.l10n.somethingWentWrong,
          );

  WidgetBuilder get _loadingIndicatorBuilder =>
      widget.builderDelegate.loadingIndicatorBuilder ??
      (_) => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: VoicesCircularProgressIndicator()),
          );

  @override
  Widget build(BuildContext context) {
    return ListenableListener(
      listenable: _pagingController,
      listener: () {
        final status = _pagingController.value.status;
        if (status == PagingStatus.loadingFirstPage) {
          _pagingController.notifyPageRequestListeners(
            0,
          );
        }
      },
      child: ValueListenableBuilder<PagingState<ItemType>>(
        valueListenable: _pagingController,
        builder: (context, pagingState, _) {
          Widget child;
          final itemList = _pagingController.itemList;

          switch (pagingState.status) {
            case PagingStatus.loading:
            case PagingStatus.loadingFirstPage:
              child = _loadingIndicatorBuilder(context);
              break;
            case PagingStatus.ongoing:
            case PagingStatus.completed:
              child = Wrap(
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
              );
              break;

            case PagingStatus.error:
              child = _errorIndicatorBuilder(context);
          }

          if (widget.builderDelegate.animateTransition) {
            child = AnimatedSwitcher(
              duration: widget.builderDelegate.transitionDuration,
              child: child,
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              _Controls(
                fromNumber: pagingState.fromValue,
                toNumber: pagingState.toValue,
                maxResults: pagingState.maxResults,
                onNextPageTap: pagingState.isLastPage
                    ? null
                    : () => _onNextPageTap(pagingState),
                onPrevPageTap: pagingState.isFirstPage ? null : _onPrevPageTap,
              ),
            ],
          );
        },
      ),
    );
  }

  void _onPrevPageTap() {
    _pagingController.prevPage();
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
