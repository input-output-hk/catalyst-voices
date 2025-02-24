import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentErrorText extends StatelessWidget {
  final String? text;
  final bool enabled;

  const DocumentErrorText({
    super.key,
    required this.text,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text ?? context.l10n.snackbarErrorLabelText,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color:
                enabled ? theme.colorScheme.error : theme.colors.textDisabled,
          ),
    );
  }
}
