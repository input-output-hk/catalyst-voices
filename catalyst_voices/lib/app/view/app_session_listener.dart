import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Listens globally to a session and can show different
/// snackBars when a session changes.
class GlobalSessionListener extends StatelessWidget {
  final Widget child;

  const GlobalSessionListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listenWhen: _listenToSessionChangesWhen,
      listener: _onSessionChanged,
      child: child,
    );
  }

  bool _listenToSessionChangesWhen(SessionState prev, SessionState next) {
    // We deliberately check if previous was guest because we don't
    // want to show the snackbar after the registration is completed.
    final keychainUnlocked =
        prev is GuestSessionState && next is ActiveAccountSessionState;

    final keychainLocked =
        prev is ActiveAccountSessionState && next is GuestSessionState;

    return keychainUnlocked || keychainLocked;
  }

  void _onSessionChanged(BuildContext context, SessionState state) {
    if (state is ActiveAccountSessionState) {
      _onUnlockedKeychain(context);
    } else if (state is GuestSessionState) {
      _onLockedKeychain(context);
    }
  }

  void _onUnlockedKeychain(BuildContext context) {
    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      icon: VoicesAssets.icons.lockOpen.buildIcon(),
      title: context.l10n.unlockSnackbarTitle,
      message: context.l10n.unlockSnackbarMessage,
    ).show(context);
  }

  void _onLockedKeychain(BuildContext context) {
    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      icon: VoicesAssets.icons.lockClosed.buildIcon(),
      title: context.l10n.lockSnackbarTitle,
      message: context.l10n.lockSnackbarMessage,
    ).show(context);
  }
}
