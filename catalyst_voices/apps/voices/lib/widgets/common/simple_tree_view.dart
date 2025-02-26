import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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

class SimpleTreeViewChildRow extends StatelessWidget {
  final bool hasNext;
  final bool isSelected;
  final bool hasError;
  final VoidCallback? onTap;
  final Widget child;

  const SimpleTreeViewChildRow({
    super.key,
    this.hasNext = true,
    this.isSelected = false,
    this.hasError = false,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final widgetStates = {
      if (hasError) WidgetState.error,
      if (isSelected) WidgetState.selected,
    };

    final backgroundColor =
        _BackgroundColor(theme.colors, theme.colorScheme).resolve(widgetStates);
    final foregroundColor =
        _ForegroundColor(theme.colors).resolve(widgetStates);

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
              child: Stack(
                children: [
                  if (hasError && isSelected) const _SelectedErrorIndicator(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _SimpleTreeViewIndent(showBottomJoint: hasNext),
                        Expanded(child: child),
                        if (hasError) const _Error(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

class _BackgroundColor extends WidgetStateProperty<Color?> {
  final VoicesColorScheme colors;
  final ColorScheme colorScheme;

  _BackgroundColor(this.colors, this.colorScheme);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.error)) {
      return colors.onSurfaceNeutralOpaqueLv1;
    } else if (states.contains(WidgetState.selected)) {
      return colorScheme.primary;
    } else {
      return null;
    }
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: VoicesAssets.icons.exclamationCircle.buildIcon(
        size: 18,
        color: Theme.of(context).colors.iconsError,
      ),
    );
  }
}

class _ForegroundColor extends WidgetStateProperty<Color?> {
  final VoicesColorScheme colors;

  _ForegroundColor(this.colors);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.error)) {
      return colors.textOnPrimaryLevel0;
    } else if (states.contains(WidgetState.selected)) {
      return colors.textOnPrimaryWhite;
    } else {
      return colors.textOnPrimaryLevel0;
    }
  }
}

class _SelectedErrorIndicator extends StatelessWidget {
  const _SelectedErrorIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: double.infinity,
      color: Theme.of(context).colors.iconsError,
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
