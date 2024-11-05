import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesScrollbar extends StatelessWidget {
  final bool alwaysVisible;
  final ScrollController? controller;
  final double mainAxisMargin;
  final double crossAxisMargin;
  final EdgeInsets padding;
  final Widget child;

  const VoicesScrollbar({
    super.key,
    this.alwaysVisible = false,
    this.controller,
    this.mainAxisMargin = 0.0,
    this.crossAxisMargin = 0.0,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawScrollbar(
      controller: controller,
      thumbVisibility: alwaysVisible,
      trackVisibility: alwaysVisible,
      thickness: 8,
      trackColor: theme.colors.onSurfaceNeutral012,
      thumbColor: theme.colorScheme.primary,
      shape: const StadiumBorder(),
      mainAxisMargin: mainAxisMargin,
      crossAxisMargin: crossAxisMargin,
      padding: padding,
      child: child,
    );
  }
}
