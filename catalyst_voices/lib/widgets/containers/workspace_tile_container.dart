import 'package:flutter/material.dart';

/// Opinionated container usual used inside space main body.
class WorkspaceTileContainer extends StatelessWidget {
  final bool isSelected;
  final Widget content;

  const WorkspaceTileContainer({
    super.key,
    this.isSelected = false,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedContainer(
        duration: kThemeChangeDuration,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.horizontal(
            left: isSelected ? Radius.zero : Radius.circular(28),
            right: Radius.circular(28),
          ),
          boxShadow: theme.brightness == Brightness.light
              ? [
                  BoxShadow(
                    color: Color(0x1F123CD3),
                    offset: Offset(0, 1),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        foregroundDecoration: BoxDecoration(
          border: Border(
            left: isSelected
                ? BorderSide(color: theme.colorScheme.primary, width: 5)
                : BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: content,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(28),
                bottomLeft: Radius.circular(isSelected ? 0 : 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
