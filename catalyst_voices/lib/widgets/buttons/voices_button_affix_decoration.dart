import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:flutter/material.dart';

/// Adding SizedBox.shrink because we want spacing on both sites.
///
/// See [AffixDecorator] for more context.
///
/// Note:
/// This widget should not be exported outside of this package.
class VoicesButtonAffixDecoration extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget child;

  const VoicesButtonAffixDecoration({
    super.key,
    this.leading,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AffixDecorator(
      prefix: leading ?? (trailing != null ? const SizedBox.shrink() : null),
      suffix: trailing ?? (leading != null ? const SizedBox.shrink() : null),
      child: child,
    );
  }
}
