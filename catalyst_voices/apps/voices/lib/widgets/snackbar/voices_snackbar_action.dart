import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesSnackBarPrimaryAction extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const VoicesSnackBarPrimaryAction({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Theme.of(context).colors.textPrimary,
        ),
        child: child,
      ),
    );
  }
}

class VoicesSnackBarSecondaryAction extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const VoicesSnackBarSecondaryAction({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Theme.of(context).colors.textPrimary,
          decoration: TextDecoration.underline,
        ),
        child: child,
      ),
    );
  }
}
