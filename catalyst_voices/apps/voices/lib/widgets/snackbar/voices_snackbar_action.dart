import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:flutter/material.dart';

class VoicesSnackBarPrimaryAction extends StatelessWidget {
  final VoicesSnackBarType type;
  final VoidCallback onPressed;
  final Widget child;

  const VoicesSnackBarPrimaryAction({
    super.key,
    required this.type,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: TextStyle(
          color: type.actionColor(context),
        ),
        child: child,
      ),
    );
  }
}

class VoicesSnackBarSecondaryAction extends StatelessWidget {
  final VoicesSnackBarType type;
  final VoidCallback onPressed;
  final Widget child;

  const VoicesSnackBarSecondaryAction({
    super.key,
    required this.type,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: TextStyle(
          color: type.actionColor(context),
          decoration: TextDecoration.underline,
        ),
        child: child,
      ),
    );
  }
}
