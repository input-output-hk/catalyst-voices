import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class RegistrationStageMessage extends StatelessWidget {
  final String title;
  final String subtitle;
  final double spacing;
  final Color? textColor;

  const RegistrationStageMessage({
    super.key,
    required this.title,
    required this.subtitle,
    this.spacing = 24,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = this.textColor ?? theme.colors.textOnPrimaryLevel0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        SizedBox(height: spacing),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
