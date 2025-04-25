import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

const _borderRadius = Radius.circular(28);
const _borderSideWidth = 5.0;

/// Opinionated container usually used inside space main body.
class BaseTile extends StatefulWidget {
  final WidgetStatesController? statesController;
  final Widget child;

  const BaseTile({
    super.key,
    this.statesController,
    required this.child,
  });

  @override
  State<BaseTile> createState() => _BaseTileState();
}

class _BaseTileState extends State<BaseTile> {
  WidgetStatesController? _statesController;

  WidgetStatesController get _effectiveStatesController {
    return widget.statesController ??
        (_statesController ??= WidgetStatesController());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedOrError = WidgetState.selected | WidgetState.error;

    final borderRadius = WidgetStateProperty.fromMap(
      <WidgetStatesConstraint, BorderRadius>{
        selectedOrError: const BorderRadius.horizontal(
          left: Radius.zero,
          right: _borderRadius,
        ),
        WidgetState.any: const BorderRadius.all(_borderRadius),
      },
    );

    final leftBorderSide = WidgetStateProperty.fromMap(
      <WidgetStatesConstraint, BorderSide>{
        WidgetState.error: BorderSide(
          color: theme.colorScheme.error,
          width: _borderSideWidth,
        ),
        WidgetState.selected: BorderSide(
          color: theme.colorScheme.primary,
          width: _borderSideWidth,
        ),
        WidgetState.any: BorderSide.none,
      },
    );

    return ValueListenableBuilder(
      valueListenable: _effectiveStatesController,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: kThemeChangeDuration,
          decoration: BoxDecoration(
            color: theme.colors.elevationsOnSurfaceNeutralLv1White,
            borderRadius: borderRadius.resolve(value),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            border: Border(
              left: leftBorderSide.resolve(value),
            ),
          ),
          child: ClipRRect(
            borderRadius: borderRadius.resolve(value),
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _statesController?.dispose();
    _statesController = null;

    super.dispose();
  }
}
