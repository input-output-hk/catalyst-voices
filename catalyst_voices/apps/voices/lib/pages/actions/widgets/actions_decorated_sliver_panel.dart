import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class ActionsDecoratedSliverPanel extends StatelessWidget {
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Widget? sliver;

  const ActionsDecoratedSliverPanel({
    super.key,
    this.sliver,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: borderRadius,
      ),
      sliver: SliverPadding(
        padding: padding,
        sliver: sliver,
      ),
    );
  }
}
