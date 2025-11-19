import 'dart:async';

import 'package:catalyst_voices/pages/registration/registration_dialog.dart'
    deferred as registration_dialog;
import 'package:catalyst_voices/pages/registration/registration_type.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_lock_button.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_unlock_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Displays current session action and toggling to next when clicked.
class SessionCtaAction extends StatelessWidget {
  const SessionCtaAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return switch (state.status) {
          SessionStatus.visitor =>
            state.isRegistrationInProgress
                ? const _FinishRegistrationButton()
                : const _GetStartedButton(),
          SessionStatus.guest => const SessionUnlockButton(),
          SessionStatus.actor => const SessionLockButton(),
        };
      },
    );
  }
}

class _FinishRegistrationButton extends StatelessWidget {
  const _FinishRegistrationButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('FinishRegistrationButton'),
      onTap: () async => _onFinishRegistrationTap(context),
      child: Text(context.l10n.finishAccountCreation),
    );
  }

  Future<void> _onFinishRegistrationTap(BuildContext context) async {
    await registration_dialog.loadLibrary();

    if (!context.mounted) return;

    await registration_dialog.RegistrationDialog.show(
      context,
      type: const ContinueRegistration(),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('GetStartedButton'),
      onTap: () async => _onGetStartedTap(context),
      child: Text(context.l10n.getStarted, semanticsIdentifier: 'GetStartedButton'),
    );
  }

  Future<void> _onGetStartedTap(BuildContext context) async {
    await registration_dialog.loadLibrary();

    if (!context.mounted) return;

    await registration_dialog.RegistrationDialog.show(
      context,
      type: const FreshRegistration(),
    );
  }
}
