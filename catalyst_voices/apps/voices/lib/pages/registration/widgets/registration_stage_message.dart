import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class RegistrationStageMessage extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
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
        DefaultTextStyle(
          key: const Key('RegistrationDetailsTitle'),
          style: theme.textTheme.titleMedium!.copyWith(color: textColor),
          child: title,
        ),
        SizedBox(height: spacing),
        DefaultTextStyle(
          key: const Key('RegistrationDetailsBody'),
          style: theme.textTheme.bodyMedium!.copyWith(color: textColor),
          child: subtitle,
        ),
      ],
    );
  }
}
