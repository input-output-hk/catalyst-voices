import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentErrorText extends StatelessWidget {
  final String? text;

  const DocumentErrorText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? context.l10n.snackbarErrorLabelText,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
    );
  }
}
