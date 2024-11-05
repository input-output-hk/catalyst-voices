import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A [GetStartedButton] widget that is used to display a call to action to
/// start an account registration.
class GetStartedButton extends StatelessWidget {
  final VoidCallback? onPressed;

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
