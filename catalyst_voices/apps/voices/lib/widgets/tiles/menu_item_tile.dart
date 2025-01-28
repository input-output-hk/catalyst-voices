import 'package:catalyst_voices/common/ext/build_context_ext.dart';
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

    return Container(
      constraints: const BoxConstraints.tightFor(height: 40),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _AffixDecoration(child: leading),
          const SizedBox(width: 12),
          Expanded(child: _TitleDecoration(child: title)),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            _AffixDecoration(child: trailing),
          ],
        ],
      ),
    );
  }
}

class _AffixDecoration extends StatelessWidget {
  final Widget child;

  const _AffixDecoration({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        size: 24,
        color: context.colors.iconsForeground,
      ),
      child: child,
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
