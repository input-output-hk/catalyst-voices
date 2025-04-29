import 'package:catalyst_voices/widgets/headers/segment_header.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Opinionated container usual used inside space main body.
class WorkspaceTextTileContainer extends StatelessWidget {
  final String name;
  final List<Widget> headerActions;
  final String content;
  final Widget? footer;

  const WorkspaceTextTileContainer({
    super.key,
    required this.name,
    this.headerActions = const [],
    required this.content,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(name, headerActions),
        _Content(child: content),
        _Footer(child: footer),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String child;

  const _Content({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimary,
    );

    return DefaultTextStyle(
      style: style,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(child),
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
      constraints: const BoxConstraints(minHeight: 16),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final List<Widget> actions;

  const _Header(this.name, this.actions);

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
