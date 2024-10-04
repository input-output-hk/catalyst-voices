import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

// Note:
// This widget does not support multi-level nesting yet because
// it was too complex to implement while we'll have
// option from google (https://pub.dev/packages/two_dimensional_scrollables)
// which will be hopefully fixed by time we'll need more nesting.
class SimpleTreeView extends StatelessWidget {
  final Widget root;
  final List<Widget> children;
  final bool isExpanded;

  const SimpleTreeView({
    super.key,
    this.isExpanded = false,
    required this.root,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        root,
        if (isExpanded) ...children,
      ],
    );
  }
}

class SimpleTreeViewRootRow extends StatelessWidget {
  final List<Widget> leading;
  final VoidCallback? onTap;
  final Widget child;

  const SimpleTreeViewRootRow({
    super.key,
    this.leading = const [],
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final color = theme.colorScheme.primary;

    final textStyle = (textTheme.titleSmall ?? const TextStyle()).copyWith(
      color: color,
    );

    final iconTheme = IconThemeData(size: 24, color: color);

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: IconTheme(
        data: iconTheme,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(height: 32),
          child: Material(
            type: MaterialType.transparency,
            textStyle: textStyle,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ...leading,
                    Flexible(child: child),
                  ].separatedBy(const SizedBox(width: 4)).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleTreeViewChildRow extends StatelessWidget {
  final bool hasNext;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget child;

  const SimpleTreeViewChildRow({
    super.key,
    this.hasNext = true,
    this.isSelected = false,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final backgroundColor = isSelected ? theme.colorScheme.primary : null;
    final foregroundColor = isSelected
        ? theme.colors.textOnPrimaryWhite
        : theme.colors.textOnPrimaryLevel0;

    final textStyle = (textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: foregroundColor,
    );

    final dividerTheme = DividerThemeData(
      color: foregroundColor,
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: DividerTheme(
        data: dividerTheme,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(height: 40),
          child: Material(
            type: backgroundColor != null
                ? MaterialType.canvas
                : MaterialType.transparency,
            color: backgroundColor,
            textStyle: textStyle,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _SimpleTreeViewIndent(showBottomJoint: hasNext),
                    Flexible(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleTreeViewIndent extends StatelessWidget {
  final bool showBottomJoint;

  const _SimpleTreeViewIndent({
    this.showBottomJoint = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24)
          .add(const EdgeInsets.symmetric(horizontal: 4)),
      child: SizedBox(
        width: 24,
        child: _SimpleTreeViewIndentJoint(showBottom: showBottomJoint),
      ),
    );
  }
}

class _SimpleTreeViewIndentJoint extends StatelessWidget {
  final bool showBottom;

  const _SimpleTreeViewIndentJoint({
    this.showBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            const Expanded(child: VerticalDivider()),
            Expanded(
              child: Offstage(
                offstage: !showBottom,
                child: const VerticalDivider(),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Spacer(),
            Expanded(child: Divider(endIndent: 3)),
          ],
        ),
      ],
    );
  }
}
