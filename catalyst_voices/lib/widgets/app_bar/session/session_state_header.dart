import 'dart:async';

import 'package:catalyst_voices/pages/account/account_popup.dart';
import 'package:catalyst_voices/routes/routing/account_route.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays current session state.
class SessionStateHeader extends StatelessWidget {
  const SessionStateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return switch (state) {
          VisitorSessionState() => const _VisitorButton(),
          GuestSessionState() => const _GuestButton(),
          ActiveUserSessionState(:final user) => AccountPopup(
              avatarLetter: user.acronym,
              onLockAccountTap: () => _onLockAccount(context),
              onProfileKeychainTap: () => _onSeeProfile(context),
            ),
        };
      },
    );
  }

  void _onLockAccount(BuildContext context) {
    context.read<SessionBloc>().add(const LockSessionEvent());

    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      icon: VoicesAssets.icons.lockClosed.buildIcon(),
      title: context.l10n.lockSnackbarTitle,
      message: context.l10n.lockSnackbarMessage,
    ).show(context);
  }

  void _onSeeProfile(BuildContext context) {
    unawaited(
      const AccountRoute().push<void>(context),
    );
  }
}

class _GuestButton extends StatelessWidget {
  const _GuestButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      child: Text(context.l10n.guest),
      onTap: () {},
    );
  }
}

class _VisitorButton extends StatelessWidget {
  const _VisitorButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      child: Text(context.l10n.visitor),
      onTap: () {},
    );
  }
}
