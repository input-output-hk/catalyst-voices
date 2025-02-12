import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  ItemType item,
);

class PagedWrapChildBuilder<ItemType> {
  final ItemWidgetBuilder<ItemType> builder;
  final WidgetBuilder? loadingIndicatorBuilder;
  final WidgetBuilder? errorIndicatorBuilder;
  final WidgetBuilder emptyIndicatorBuilder;
  final bool animateTransition;
  final Duration transitionDuration;

  const PagedWrapChildBuilder({
    required this.builder,
    required this.emptyIndicatorBuilder,
    this.loadingIndicatorBuilder,
    this.errorIndicatorBuilder,
    this.animateTransition = false,
    this.transitionDuration = const Duration(milliseconds: 200),
  });
}
