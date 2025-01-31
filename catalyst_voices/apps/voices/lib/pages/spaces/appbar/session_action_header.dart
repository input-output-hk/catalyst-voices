import 'dart:async';

import 'package:catalyst_voices/pages/account/unlock_keychain_dialog.dart';
import 'package:catalyst_voices/pages/registration/registration_dialog.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_lock_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays current session action and toggling to next when clicked.
class SessionActionHeader extends StatelessWidget {
  const SessionActionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return switch (state.status) {
          SessionStatus.visitor => state.isRegistrationInProgress
              ? const _FinishRegistrationButton()
              : _GetStartedButton(isEnabled: state.canCreateAccount),
          SessionStatus.guest => const _UnlockButton(),
          SessionStatus.actor => const SessionLockButton(),
        };
      },
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final bool isEnabled;

  const _GetStartedButton({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('GetStartedButton'),
      onTap: isEnabled ? () async => RegistrationDialog.show(context) : null,
      child: Text(context.l10n.getStarted),
    );
  }
}

class _FinishRegistrationButton extends StatelessWidget {
  const _FinishRegistrationButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () => unawaited(RegistrationDialog.show(context)),
      child: Text(context.l10n.finishAccountCreation),
    );
  }
}

class _UnlockButton extends StatelessWidget {
  const _UnlockButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('UnlockButton'),
      trailing: VoicesAssets.icons.lockOpen.buildIcon(),
      onTap: () => unawaited(UnlockKeychainDialog.show(context)),
      child: Text(context.l10n.unlock),
    );
  }
}
