import 'package:catalyst_voices/widgets/common/semantics/combine_semantics.dart';
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
    return CombineSemantics(
      identifier: 'DocumentErrorText',
      container: true,
      child: Text(
        text ?? context.l10n.snackbarErrorLabelText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: enabled ? theme.colorScheme.error : theme.colors.textDisabled,
        ),
      ),
    );
  }
}
