import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VoicesDrawerHeader extends StatelessWidget {
  final VoidCallback? onCloseTap;
  final bool showBackButton;
  final Widget title;

  const VoicesDrawerHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: context.pop,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.only(right: 8),
            ),
          ),
        Expanded(child: _Title(child: title)),
        CloseButton(
          onPressed: onCloseTap != null ? onCloseTap!.call : Navigator.maybeOf(context)?.pop,
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final Widget child;

  const _Title({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.titleLarge ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );
    final iconThemeData = IconThemeData(
      size: 24,
      color: context.colors.iconsForeground,
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: IconTheme(
        data: iconThemeData,
        child: child,
      ),
    );
  }
}
