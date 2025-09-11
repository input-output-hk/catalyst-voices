import 'package:catalyst_voices/pages/registration/registration_error_handler.dart';
import 'package:flutter/material.dart';

class RegistrationDialogScaffold extends StatelessWidget {
  final Widget child;

  const RegistrationDialogScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RegistrationErrorHandler(
          child: child,
        ),
      ),
    );
  }
}
