import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/registration/pictures/unlock_keychain_picture.dart';
import 'package:catalyst_voices/pages/registration/registration_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/information_panel.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog which allows to unlock the session (keychain).
class UnlockKeychainDialog extends StatefulWidget {
  const UnlockKeychainDialog({super.key});

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/unlock'),
      builder: (context) => const UnlockKeychainDialog(),
      barrierDismissible: false,
    );
  }

  @override
  State<UnlockKeychainDialog> createState() => _UnlockKeychainDialogState();
}

class _UnlockKeychainDialogState extends State<UnlockKeychainDialog>
    with ErrorHandlerStateMixin<SessionBloc, UnlockKeychainDialog> {
  final TextEditingController _passwordController = TextEditingController();
  LocalizedException? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void handleError(Object error) {
    setState(() {
      _error = error is LocalizedException
          ? error
          : const LocalizedUnlockPasswordException();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: _handleSessionChange,
      child: VoicesTwoPaneDialog(
        left: InformationPanel(
          title: context.l10n.unlockDialogHeader,
          picture: const UnlockKeychainPicture(),
        ),
        right: _UnlockPasswordPanel(
          controller: _passwordController,
          error: _error,
          onUnlock: _onUnlock,
          onRecover: _onRecover,
        ),
      ),
    );
  }

  void _handleSessionChange(BuildContext context, SessionState state) {
    if (state is ActiveUserSessionState) {
      Navigator.of(context).pop();
    }
  }

  void _onUnlock() {
    setState(() {
      _error = null;
    });

    final password = _passwordController.text;
    final unlockFactor = PasswordLockFactor(password);
    context
        .read<SessionBloc>()
        .add(UnlockSessionEvent(unlockFactor: unlockFactor));
  }

  void _onRecover() {
    Navigator.of(context).pop();

    unawaited(
      RegistrationDialog.show(
        context,
        step: const RecoverMethodStep(),
      ),
    );
  }
}

class _UnlockPasswordPanel extends StatelessWidget {
  final TextEditingController controller;
  final LocalizedException? error;
  final VoidCallback onUnlock;
  final VoidCallback onRecover;

  const _UnlockPasswordPanel({
    required this.controller,
    required this.error,
    required this.onUnlock,
    required this.onRecover,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: Text(context.l10n.unlockDialogTitle),
          subtitle: Text(context.l10n.unlockDialogContent),
        ),
        const SizedBox(height: 24),
        _UnlockPassword(
          controller: controller,
          error: error,
        ),
        const Spacer(),
        _Navigation(
          onUnlock: onUnlock,
          onRecover: onRecover,
        ),
      ],
    );
  }
}

class _UnlockPassword extends StatelessWidget {
  final TextEditingController controller;
  final LocalizedException? error;

  const _UnlockPassword({
    required this.controller,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPasswordTextField(
      controller: controller,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.unlockDialogHint,
        errorText: error?.message(context),
        hintText: context.l10n.passwordLabelText,
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  final VoidCallback onUnlock;
  final VoidCallback onRecover;

  const _Navigation({
    required this.onUnlock,
    required this.onRecover,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesFilledButton(
          onTap: onUnlock,
          child: Text(context.l10n.confirmPassword),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: VoicesOutlinedButton(
                onTap: onRecover,
                child: Text(context.l10n.recoverAccount),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: VoicesTextButton(
                onTap: () => Navigator.of(context).pop(),
                child: Text(context.l10n.continueAsGuest),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
