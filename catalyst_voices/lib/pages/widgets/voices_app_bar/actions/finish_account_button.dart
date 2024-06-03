import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class FinishAccountButton extends StatelessWidget {
  final void Function()? onPressed;

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
