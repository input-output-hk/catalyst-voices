import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class NextStep extends StatelessWidget {
  final String? data;

  const NextStep(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        VoicesTextDivider(child: Text(context.l10n.yourNextStep)),
        const SizedBox(height: 12),
        if (data != null)
          Text(
            data!,
            style: theme.textTheme.bodySmall?.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
        if (data != null) const SizedBox(height: 12),
      ],
    );
  }
}
