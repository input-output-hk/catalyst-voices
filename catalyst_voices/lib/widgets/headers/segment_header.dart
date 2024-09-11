import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SegmentHeader extends StatelessWidget {
  final String name;
  final Widget? leading;
  final List<Widget> actions;
  final bool isSelected;
  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? foregroundColor;

  const SegmentHeader({
    super.key,
    required this.name,
    this.leading,
    this.actions = const [],
    this.isSelected = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  Set<WidgetState> get states => {
        if (isSelected) WidgetState.selected,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBackgroundColor = backgroundColor ??
        _DefaultBackgroundColor(
          theme.colorScheme,
          theme.colors,
        );
    final effectiveForegroundColor = backgroundColor ??
        _DefaultForegroundColor(
          theme.colorScheme,
          theme.colors,
        );

    final iconButtonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
      iconColor: WidgetStatePropertyAll(
        effectiveForegroundColor.resolve(states),
      ),
    );
    final textButtonStyle = ButtonStyle(
      foregroundColor: effectiveForegroundColor,
    );

    final textStyle = (theme.textTheme.titleMedium ?? TextStyle())
        .copyWith(color: effectiveForegroundColor.resolve(states));

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
              color: effectiveBackgroundColor.resolve(states),
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
  final VoicesColorScheme colors;

  _DefaultBackgroundColor(
    this.colorScheme,
    this.colors,
  );

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return colorScheme.primary;
    }

    return null;
  }
}

final class _DefaultForegroundColor implements WidgetStateProperty<Color?> {
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  _DefaultForegroundColor(
    this.colorScheme,
    this.colors,
  );

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
