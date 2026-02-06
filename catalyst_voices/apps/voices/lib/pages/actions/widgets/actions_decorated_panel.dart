import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class ActionsDecoratedPanel extends StatelessWidget {
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Widget? child;

  const ActionsDecoratedPanel({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
