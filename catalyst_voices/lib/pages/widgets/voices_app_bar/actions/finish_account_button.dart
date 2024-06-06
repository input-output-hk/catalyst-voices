import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A [FinishAccountButton] widget that is used to display a call to action to
/// complete a pending account registration.
class FinishAccountButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FinishAccountButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(context.l10n.finishAccountButtonLabelText),
    );
  }
}
