import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/registration/pictures/unlock_keychain_picture.dart';
import 'package:catalyst_voices/pages/registration/widgets/information_panel.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog which allows to unlock the session (keychain).
class UnlockKeychainDialog extends StatelessWidget {
  const UnlockKeychainDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesTwoPaneDialog(
      left: InformationPanel(
        title: context.l10n.unlockDialogHeader,
        picture: const UnlockKeychainPicture(),
      ),
      right: const _UnlockPasswordPanel(),
    );
  }

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/unlock'),
      builder: (context) => const UnlockKeychainDialog(),
      barrierDismissible: false,
    );
  }
}

class _UnlockPasswordPanel extends StatefulWidget {
  const _UnlockPasswordPanel();

  @override
  State<_UnlockPasswordPanel> createState() => _UnlockPasswordPanelState();
}

class _UnlockPasswordPanelState extends State<_UnlockPasswordPanel>
    with ErrorHandlerStateMixin<SessionBloc, _UnlockPasswordPanel> {
  final TextEditingController _passwordController = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void handleError(Object error) {
    setState(() {
      _showError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is ActiveUserSessionState) {
          // TODO: show snackbar
          // TODO show snackbar when locking
          Navigator.of(context).pop();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          RegistrationStageMessage(
            title: Text(context.l10n.unlockDialogTitle),
            subtitle: Text(context.l10n.unlockDialogContent),
          ),
          const SizedBox(height: 24),
          _UnlockPassword(
            controller: _passwordController,
            showError: _showError,
          ),
          const Spacer(),
          _Navigation(
            onUnlock: _onUnlock,
          ),
        ],
      ),
    );
  }

  void _onUnlock() {
    setState(() {
      _showError = false;
    });

    final password = _passwordController.text;
    final unlockFactor = PasswordLockFactor(password);
    context
        .read<SessionBloc>()
        .add(UnlockSessionEvent(unlockFactor: unlockFactor));
  }
}

class _UnlockPassword extends StatelessWidget {
  final TextEditingController controller;
  final bool showError;

  const _UnlockPassword({
    required this.controller,
    required this.showError,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPasswordTextField(
      controller: controller,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.unlockDialogHint,
        errorText:
            showError ? context.l10n.unlockDialogIncorrectPassword : null,
        hintText: '***********',
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  final VoidCallback onUnlock;

  const _Navigation({
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VoicesOutlinedButton(
            onTap: () => Navigator.of(context).pop(),
            child: Text(context.l10n.continueAsGuest),
          ),
        ),
        Expanded(
          child: VoicesFilledButton(
            onTap: onUnlock,
            child: Text(context.l10n.confirmPassword),
          ),
        ),
      ],
    );
  }
}
