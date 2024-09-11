import 'package:catalyst_voices/widgets/headers/segment_header.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Opinionated container usual used inside space main body.
class WorkspaceTileContainer extends StatelessWidget {
  final bool isSelected;
  final String name;
  final List<Widget> headerActions;
  final Widget content;
  final Widget? footer;

  const WorkspaceTileContainer({
    super.key,
    this.isSelected = false,
    required this.name,
    this.headerActions = const [],
    required this.content,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: kThemeChangeDuration,
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.horizontal(
          left: isSelected ? Radius.zero : Radius.circular(28),
          right: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colors.elevationsOnSurfaceNeutralLv0!,
            offset: Offset(0, 1),
            blurRadius: 8,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(name, headerActions),
          _Content(child: content),
          _Footer(child: footer),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final List<Widget> actions;

  _Header(this.name, this.actions);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SegmentHeader(
        name: name,
        actions: actions,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Widget child;

  const _Content({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = (theme.textTheme.bodyMedium ?? TextStyle()).copyWith(
      color: theme.colors.textOnPrimary,
    );

    return DefaultTextStyle(
      style: style,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: child,
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final Widget? child;

  const _Footer({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 16),
      child: child,
    );
  }
}
