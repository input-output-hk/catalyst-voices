import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class GetStartedButton extends StatelessWidget {
  final void Function()? onPressed;

  const GetStartedButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(context.l10n.getStartedButtonLabelText),
    );
  }
}
