import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class RegistrationDetailsPanelScaffold extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final Widget? footer;

  const RegistrationDetailsPanelScaffold({
    super.key,
    this.title,
    required this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final footer = this.footer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        if (title != null) ...[
          _TitleDefaultStyle(child: title),
          const SizedBox(height: 24),
        ],
        Expanded(child: body),
        if (footer != null) ...[const SizedBox(height: 8), footer],
      ],
    );
  }
}

class _TitleDefaultStyle extends StatelessWidget {
  final Widget child;

  const _TitleDefaultStyle({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.textOnPrimaryLevel1;
    final textStyle = theme.textTheme.titleMedium ?? const TextStyle();

    return DefaultTextStyle(
      style: textStyle.copyWith(color: color),
      textAlign: TextAlign.start,
      child: child,
    );
  }
}
