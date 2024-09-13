import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
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

    return AnimatedContainer(
      duration: kThemeChangeDuration,
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: _borderRadius(isSelected),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0!,
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        border: Border(
          left: isSelected
              ? BorderSide(
                  color: theme.colorScheme.primary,
                  width: 5,
                )
              : BorderSide.none,
        ),
      ),
      child: ClipRRect(
        child: content,
        borderRadius: _borderRadius(isSelected),
      ),
    );
  }
}

BorderRadius _borderRadius(bool isSelected) => BorderRadius.horizontal(
  left: isSelected ? Radius.zero : Radius.circular(28),
  right: Radius.circular(28),
);


