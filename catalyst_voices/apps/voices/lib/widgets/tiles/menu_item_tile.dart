import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:flutter/material.dart';

class MenuItemTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MenuItemTile({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 40),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AffixDecorator(
              gap: 12,
              iconTheme: IconThemeData(
                size: 24,
                color: context.colors.iconsForeground,
              ),
              prefix: leading,
              suffix: trailing,
              mainAxisSize: MainAxisSize.max,
              child: _TitleDecoration(child: title),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleDecoration extends StatelessWidget {
  final Widget child;

  const _TitleDecoration({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final textStyle = (textTheme.bodyLarge ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }
}
