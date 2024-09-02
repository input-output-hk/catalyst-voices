import 'package:flutter/material.dart';

class SegmentHeader extends StatelessWidget {
  final String name;
  final Widget? leading;
  final List<Widget> actions;
  final bool isHighlighted;

  const SegmentHeader({
    super.key,
    required this.name,
    this.leading,
    this.actions = const [],
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final backgroundColor = isHighlighted ? colors.primary : null;
    final foregroundColor = isHighlighted ? colors.onPrimary : colors.primary;

    final iconButtonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
      iconColor: WidgetStatePropertyAll(foregroundColor),
    );

    final textStyle = (theme.textTheme.titleMedium ?? TextStyle())
        .copyWith(color: foregroundColor);

    return IconButtonTheme(
      data: IconButtonThemeData(style: iconButtonStyle),
      child: AnimatedDefaultTextStyle(
        duration: kThemeChangeDuration,
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: AnimatedContainer(
          duration: kThemeChangeDuration,
          constraints: BoxConstraints(minHeight: 52),
          decoration: BoxDecoration(color: backgroundColor),
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
    );
  }
}
