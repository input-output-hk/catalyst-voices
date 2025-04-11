import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Listens globally to a session and can show different
/// snackBars when a session changes.
class GlobalSessionListener extends StatefulWidget {
  final Widget child;

  const GlobalSessionListener({
    super.key,
    required this.child,
  });

  @override
  State<GlobalSessionListener> createState() => _GlobalSessionListenerState();
}

class _GlobalSessionListenerState extends State<GlobalSessionListener> {
  String? _lastLocation;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listenWhen: _listenToSessionChangesWhen,
      listener: _onSessionChanged,
      child: widget.child,
    );
  }

  bool _listenToSessionChangesWhen(SessionState prev, SessionState next) {
    // We deliberately check if previous was guest because we don't
    // want to show the snackbar after the registration is completed.
    final keychainUnlocked = prev.isGuest && next.isActive;
    final keychainLocked = prev.isActive && next.isGuest;

    return keychainUnlocked || keychainLocked;
  }

  void _onLockedKeychain(BuildContext context) {
    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      icon: VoicesAssets.icons.lockClosed.buildIcon(),
      title: context.l10n.lockSnackbarTitle,
      message: context.l10n.lockSnackbarMessage,
    ).show(context);

    final routerContext = AppRouter.rootNavigatorKey.currentContext;
    if (routerContext != null) {
      _lastLocation = GoRouter.of(routerContext).state.uri.toString();
      routerContext.go(const DiscoveryRoute().location);
    }
  }

  void _onSessionChanged(BuildContext context, SessionState state) {
    if (state.isActive) {
      _onUnlockedKeychain(context);
    } else if (state.isGuest) {
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

    final routerContext = AppRouter.rootNavigatorKey.currentContext;
    if (_lastLocation != null && routerContext != null) {
      routerContext.go(_lastLocation!);
    }
  }
}
