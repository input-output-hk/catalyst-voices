import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/routes/routing/account_route.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RegistrationSignalHandler extends StatefulWidget {
  final Widget child;

  const RegistrationSignalHandler({super.key, required this.child});

  @override
  State<RegistrationSignalHandler> createState() => _RegistrationSignalHandlerState();
}

class _RegistrationSignalHandlerState extends State<RegistrationSignalHandler>
    with SignalHandlerStateMixin<RegistrationCubit, RegistrationSignal, RegistrationSignalHandler> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void handleSignal(RegistrationSignal signal) {
    switch (signal) {
      case EmailAlreadyUsedSignal():
        _showEmailAlreadyInUsedSnackbar();
    }
  }

  void _goToAccountPage(BuildContext context) {
    const AccountRoute().go(context);
  }

  void _showEmailAlreadyInUsedSnackbar() {
    VoicesSnackBar(
      type: VoicesSnackBarType.warning,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 6),
      title: context.l10n.errorEmailAlreadyInUse,
      message: context.l10n.errorEmailAlreadyInUseUpdateLater,
      actions: [
        TextButton(
          onPressed: () => _goToAccountPage(context),
          child: Text(context.l10n.account),
        ),
      ],
    ).show(context);
  }
}
