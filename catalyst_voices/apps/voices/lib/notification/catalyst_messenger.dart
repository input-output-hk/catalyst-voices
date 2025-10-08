import 'dart:async';

import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/notification/banner_close_button.dart';
import 'package:catalyst_voices/notification/banner_content.dart';
import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices/routes/app_router_factory.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _logger = Logger('CatalystMessenger');

typedef CatalystNotificationPredicate = bool Function(CatalystNotification notification);

class CatalystMessenger extends StatefulWidget {
  final Widget child;

  const CatalystMessenger({
    super.key,
    required this.child,
  });

  @override
  State<CatalystMessenger> createState() => CatalystMessengerState();

  static CatalystMessengerState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<CatalystMessengerState>();
  }

  static CatalystMessengerState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'CatalystMessenger not found in widget tree');
    return state!;
  }
}

class CatalystMessengerState extends State<CatalystMessenger> {
  final _pending = <CatalystNotification>[];
  bool _isShowing = false;
  CatalystNotification? _activeNotification;

  GoRouter? __router;

  GoRouter get _router {
    return __router ??= _findRouter()..routerDelegate.addListener(_handleRouterChange);
  }

  void add(CatalystNotification notification) {
    _logger.finest('Adding $notification to queue');

    _addSorted(notification);
    _processQueue();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void cancelWhere(CatalystNotificationPredicate test) {
    _pending.removeWhere(test);

    final activeNotification = _activeNotification;
    if (activeNotification != null && test(activeNotification)) {
      _hideCurrentBanner();
    }
  }

  @override
  void dispose() {
    __router?.routerDelegate.removeListener(_handleRouterChange);
    __router = null;

    super.dispose();
  }

  void _addSorted(CatalystNotification notification) {
    _pending
      ..add(notification)
      ..sort();
  }

  GoRouter _findRouter() {
    final navigatorContext = AppRouterFactory.rootNavigatorKey.currentContext;
    assert(navigatorContext != null, 'Navigation context not available');

    return GoRouter.of(navigatorContext!);
  }

  void _handleRouterChange() {
    final activeNotification = _activeNotification;
    if (activeNotification == null) {
      if (_pending.isNotEmpty) {
        _processQueue();
      }
      return;
    }

    final routerState = _router.state;

    // if active notification is still valid for router do nothing.
    if (activeNotification.routerPredicate(routerState)) {
      return;
    }

    _logger.finer('Hiding notification(${activeNotification.id}). Not valid for router state');

    _addSorted(activeNotification);
    _hideCurrentBanner();
  }

  /// Hiding current banner will trigger _onNotificationCompleted and process queue.
  void _hideCurrentBanner() {
    final messengerState = AppContent.scaffoldMessengerKey.currentState;
    if (messengerState == null) {
      return;
    }
    messengerState.removeCurrentMaterialBanner(reason: MaterialBannerClosedReason.hide);
  }

  void _onNotificationCompleted() {
    assert(_activeNotification != null, 'Completed notification but active was null');
    final activeNotification = _activeNotification!;

    _logger.finer('Completed $activeNotification');

    _isShowing = false;
    _activeNotification = null;

    _processQueue();
  }

  void _processQueue() {
    if (_isShowing) {
      return;
    }

    final routerState = _router.state;
    final allowed = _pending.where((notification) => notification.routerPredicate(routerState));
    if (allowed.isEmpty) {
      if (_pending.isNotEmpty) {
        _logger.finest('Found ${_pending.length} notification but none allow for router state');
      }
      return;
    }

    final notification = allowed.first;
    _pending.removeWhere((element) => element.id == notification.id);
    _activeNotification = notification;

    _isShowing = true;

    _logger.finer('Showing $notification');

    final future = switch (notification) {
      BannerNotification() => _showBanner(notification),
    };

    unawaited(future.whenComplete(_onNotificationCompleted));
  }

  Future<void> _showBanner(BannerNotification notification) async {
    final messengerState = AppContent.scaffoldMessengerKey.currentState;
    if (messengerState == null) {
      return;
    }

    final banner = MaterialBanner(
      leading: notification.type.icon.buildIcon(size: 18),
      content: BannerContent(notification: notification),
      actions: const [BannerCloseButton()],
      minActionBarHeight: 32,
      backgroundColor: notification.type.backgroundColor(context),
      contentTextStyle: (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
        color: notification.type.foregroundColor(context),
      ),
      padding: const EdgeInsetsDirectional.only(start: 24),
      leadingPadding: const EdgeInsetsDirectional.only(end: 8),
    );
    final controller = messengerState.showMaterialBanner(banner);

    return controller.closed.then(
      (reason) {
        _logger.finest('Notification(${notification.id}) closed with reason -> $reason');
      },
    );
  }
}
