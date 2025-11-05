import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/notification/catalyst_messenger.dart';
import 'package:catalyst_voices/notification/specialized/banner/account_needs_verification_banner.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
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

class _GlobalSessionListenerState extends State<GlobalSessionListener>
    with SignalHandlerStateMixin<SessionCubit, SessionSignal, GlobalSessionListener> {
  String? _lastLocation;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void handleSignal(SessionSignal signal) {
    switch (signal) {
      case AccountNeedsVerificationSignal(:final isProposer):
        final notification = isProposer
            ? AccountProposerNeedsVerificationBanner()
            : AccountContributorNeedsVerificationBanner();
        CatalystMessenger.of(context).add(notification);
      case CancelAccountNeedsVerificationSignal():
        CatalystMessenger.of(context).cancelWhere(
          (notification) => notification is AccountNeedsVerificationBanner,
        );
      case KeychainLockedSignal():
        _handleKeychainLock();
      case KeychainUnlockedSignal():
        _handleKeychainUnlock();
    }
  }

  void _handleKeychainLock() {
    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.lockSnackbarTitle,
      message: context.l10n.lockSnackbarMessage,
      icon: VoicesAssets.icons.lockClosed.buildIcon(),
    ).show(context);

    final routerContext = AppRouterFactory.rootNavigatorKey.currentContext;
    if (routerContext != null) {
      _lastLocation = GoRouter.of(routerContext).state.uri.toString();
      routerContext.go(const DiscoveryRoute().location);
    }
  }

  void _handleKeychainUnlock() {
    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.unlockSnackbarTitle,
      message: context.l10n.unlockSnackbarMessage,
      icon: VoicesAssets.icons.lockOpen.buildIcon(),
    ).show(context);

    final routerContext = AppRouterFactory.rootNavigatorKey.currentContext;
    if (_lastLocation != null && routerContext != null) {
      routerContext.go(_lastLocation!);
    }
  }
}
