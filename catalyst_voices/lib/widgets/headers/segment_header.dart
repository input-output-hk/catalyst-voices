import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SegmentHeader extends StatelessWidget {
  final String name;
  final Widget? leading;
  final List<Widget> actions;
  final bool isSelected;

  const SegmentHeader({
    super.key,
    required this.name,
    this.leading,
    this.actions = const [],
    this.isSelected = false,
  });

  Set<WidgetState> get _states => {
        if (isSelected) WidgetState.selected,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = _DefaultBackgroundColor(theme.colorScheme);
    final foregroundColor = _DefaultForegroundColor(theme.colors);

    final iconButtonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
      // resolving colors because IconButton does not have WidgetState.selected
      iconColor: WidgetStatePropertyAll(foregroundColor.resolve(_states)),
    );
    final textButtonStyle = ButtonStyle(
      foregroundColor: foregroundColor,
    );

    final textStyle = (theme.textTheme.titleMedium ?? TextStyle())
        .copyWith(color: foregroundColor.resolve(_states));

    return IconButtonTheme(
      data: IconButtonThemeData(style: iconButtonStyle),
      child: TextButtonTheme(
        data: TextButtonThemeData(style: textButtonStyle),
        child: AnimatedDefaultTextStyle(
          duration: kThemeChangeDuration,
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: AnimatedContainer(
            duration: kThemeChangeDuration,
            constraints: BoxConstraints(minHeight: 52),
            decoration: BoxDecoration(
              color: backgroundColor.resolve(_states),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) leading!,
                Expanded(child: Text(name)),
                if (actions.isNotEmpty) ...actions
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _DefaultBackgroundColor implements WidgetStateProperty<Color?> {
  final ColorScheme colorScheme;

  _DefaultBackgroundColor(this.colorScheme);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return colorScheme.primary;
    }

    return null;
  }
}

final class _DefaultForegroundColor implements WidgetStateProperty<Color?> {
  final VoicesColorScheme colors;

  _DefaultForegroundColor(this.colors);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colors.textDisabled;
    }

    if (states.contains(WidgetState.selected)) {
      return colors.textOnPrimaryWhite;
    }

    return colors.textOnPrimaryLevel0;
  }
}
