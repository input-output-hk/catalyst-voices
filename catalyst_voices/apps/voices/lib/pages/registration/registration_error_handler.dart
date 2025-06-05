import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class RegistrationErrorHandler extends StatefulWidget {
  final Widget child;

  const RegistrationErrorHandler({
    super.key,
    required this.child,
  });

  @override
  State<RegistrationErrorHandler> createState() => _RegistrationErrorHandlerState();
}

class _RegistrationErrorHandlerState extends State<RegistrationErrorHandler>
    with ErrorHandlerStateMixin<RegistrationCubit, RegistrationErrorHandler> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
