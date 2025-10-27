import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/notification/catalyst_messenger.dart';
import 'package:catalyst_voices/notification/specialized/banner/account_needs_verification_banner.dart';
import 'package:catalyst_voices/notification/specialized/snackbar/locked_keychain_snackbar.dart';
import 'package:catalyst_voices/notification/specialized/snackbar/unlocked_keychain_snackbar.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
        CatalystMessenger.of(context).add(LockedKeychainSnackbar());

        final routerContext = AppRouterFactory.rootNavigatorKey.currentContext;
        if (routerContext != null) {
          _lastLocation = GoRouter.of(routerContext).state.uri.toString();
          routerContext.go(const DiscoveryRoute().location);
        }
      case KeychainUnlockedSignal():
        CatalystMessenger.of(context).add(UnlockedKeychainSnackbar());

        final routerContext = AppRouterFactory.rootNavigatorKey.currentContext;
        if (_lastLocation != null && routerContext != null) {
          routerContext.go(_lastLocation!);
        }
    }
  }
}
