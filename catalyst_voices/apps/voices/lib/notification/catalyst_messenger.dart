import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/notification/banner_close_button.dart';
import 'package:catalyst_voices/notification/banner_content.dart';
import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices/routes/app_router_factory.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
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
  final _pendingDialogs = <DialogNotification>[];
  final _pendingBanners = <BannerNotification>[];
  bool _isShowingBanner = false;
  bool _isShowingDialog = false;
  BannerNotification? _activeBanner;
  DialogNotification? _activeDialog;

  GoRouter? __router;
  bool _routerListenerAttached = false;
  bool _retryScheduled = false;

  GoRouter? get _router {
    if (__router != null) return __router;

    final router = _tryFindRouter();
    if (router != null && !_routerListenerAttached) {
      router.routerDelegate.addListener(_handleRouterChange);
      _routerListenerAttached = true;
      __router = router;
    }
    return router;
  }

  /// Adds a notification to the queue if it is not already present.
  ///
  /// This method ensures that duplicate notifications are not added to the queue.
  /// Notifications are routed to the appropriate queue (dialogs or banners)
  /// and sorted by priority within each queue.
  void add(CatalystNotification notification) {
    _logger.finest('Adding $notification to queue');

    switch (notification) {
      case DialogNotification():
        if (_pendingDialogs.any((n) => n.id == notification.id)) {
          _logger.fine('$notification already in dialogs queue, skipping add');
          return;
        }
        _addToQueue(notification);
      case BannerNotification():
        if (_pendingBanners.any((n) => n.id == notification.id)) {
          _logger.fine('$notification already in banners queue, skipping add');
          return;
        }
        _addToQueue(notification);
    }

    _processQueue();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void cancelWhere(CatalystNotificationPredicate test) {
    _pendingDialogs.removeWhere(test);
    _pendingBanners.removeWhere(test);

    final activeDialog = _activeDialog;
    if (activeDialog != null && test(activeDialog)) {
      _hideCurrentDialog();
    }

    final activeBanner = _activeBanner;
    if (activeBanner != null && test(activeBanner)) {
      _hideCurrentBanner();
    }
  }

  @override
  void dispose() {
    __router?.routerDelegate.removeListener(_handleRouterChange);
    __router = null;

    super.dispose();
  }

  void _addToQueue(CatalystNotification notification) {
    switch (notification) {
      case BannerNotification():
        _pendingBanners
          ..add(notification)
          ..sort();
        break;
      case DialogNotification():
        _pendingDialogs
          ..add(notification)
          ..sort();
    }
  }

  GoRouter? _tryFindRouter() {
    final navigatorContext = AppRouterFactory.rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      _logger.finest('Navigation context not yet available, deferring queue processing');
      return null;
    }

    return GoRouter.of(navigatorContext);
  }

  void _handleRouterChange() {
    final router = _router;
    if (router == null) return; // Router should always exist if this listener fires

    final routerState = router.state;

    // Handle active dialog
    final activeDialog = _activeDialog;
    if (activeDialog != null && !activeDialog.routerPredicate(routerState)) {
      _logger.finer('Hiding dialog(${activeDialog.id}). Not valid for router state');
      _addToQueue(activeDialog);
      _hideCurrentDialog();
    }

    // Handle active banner
    final activeBanner = _activeBanner;
    if (activeBanner != null && !activeBanner.routerPredicate(routerState)) {
      _logger.finer('Hiding banner(${activeBanner.id}). Not valid for router state');
      _addToQueue(activeBanner);
      _hideCurrentBanner();
    }

    // Process queue if there are pending notifications
    if (_pendingDialogs.isNotEmpty || _pendingBanners.isNotEmpty) {
      _processQueue();
    }
  }

  /// Hiding current banner will trigger _onBannerCompleted and process queue.
  void _hideCurrentBanner() {
    final messengerState = ScaffoldMessenger.maybeOf(context);
    if (messengerState == null) {
      return;
    }
    messengerState.removeCurrentMaterialBanner(reason: MaterialBannerClosedReason.hide);
  }

  /// Hiding current dialog will trigger _onDialogCompleted and process queue.
  void _hideCurrentDialog() {
    final router = _router;
    if (router == null) return;

    final navigatorContext = router.routerDelegate.navigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }
    Navigator.of(navigatorContext, rootNavigator: true).pop();
  }

  void _onBannerCompleted() {
    assert(_activeBanner != null, 'Completed banner but active was null');
    final activeBanner = _activeBanner!;

    _logger.finer('Completed banner $activeBanner');

    _isShowingBanner = false;
    _activeBanner = null;

    _processQueue();
  }

  void _onDialogCompleted() {
    assert(_activeDialog != null, 'Completed dialog but active was null');
    final activeDialog = _activeDialog!;

    _logger.finer('Completed dialog $activeDialog');

    _isShowingDialog = false;
    _activeDialog = null;

    _processQueue();
  }

  void _processQueue() {
    final router = _router;
    if (router == null) {
      // Navigation context not ready yet, schedule retry after next frame
      final totalPending = _pendingDialogs.length + _pendingBanners.length;
      if (totalPending > 0 && !_retryScheduled) {
        _retryScheduled = true;
        _logger.finest('Router not available, scheduling retry for $totalPending notification(s)');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _retryScheduled = false;
          if (mounted) {
            _processQueue();
          }
        });
      }
      return;
    }

    final routerState = router.state;

    // Filter notifications that are allowed for current router state
    final allowedDialogs = _pendingDialogs.where((n) => n.routerPredicate(routerState));
    final allowedBanners = _pendingBanners.where((n) => n.routerPredicate(routerState));

    if (allowedDialogs.isEmpty && allowedBanners.isEmpty) {
      final totalPending = _pendingDialogs.length + _pendingBanners.length;
      if (totalPending > 0) {
        _logger.finest('Found $totalPending notification(s) but none allow for router state');
      }
      return;
    }

    // Get next notification respecting priority across both queues
    final nextDialog = allowedDialogs.firstOrNull;
    final nextBanner = allowedBanners.firstOrNull;

    // Banners and dialog can be shown at the same time
    if (!_isShowingDialog && nextDialog != null) {
      _pendingDialogs.removeWhere((element) => element.id == nextDialog.id);
      _activeDialog = nextDialog;
      _isShowingDialog = true;

      _logger.finer('Showing dialog $nextDialog');

      unawaited(_showDialog(nextDialog).whenComplete(_onDialogCompleted));
    }

    if (!_isShowingBanner && nextBanner != null) {
      _pendingBanners.removeWhere((element) => element.id == nextBanner.id);
      _activeBanner = nextBanner;
      _isShowingBanner = true;

      _logger.finer('Showing banner $nextBanner');

      unawaited(_showBanner(nextBanner).whenComplete(_onBannerCompleted));
    }
  }

  Future<void> _showBanner(BannerNotification notification) async {
    final messengerState = ScaffoldMessenger.maybeOf(context);
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

  Future<void> _showDialog(DialogNotification notification) async {
    // Wait for all pending frames to complete. Navigation (especially with
    // redirects) can take multiple frames. By waiting while Flutter has
    // scheduled frames, we ensure navigation has fully completed.
    await WidgetsBinding.instance.endOfFrame;

    // Check if the dialog is still active after navigation
    if (_activeDialog?.id != notification.id) {
      return;
    }

    final router = _router;
    if (router == null) {
      _logger.finest('Router not available when showing dialog ${notification.id}');
      return;
    }

    // Verify the dialog is still allowed for the current route
    if (!notification.routerPredicate(router.state)) {
      _logger.finer('Dialog ${notification.id} no longer valid for current route after navigation');
      return;
    }

    final navigatorContext = router.routerDelegate.navigatorKey.currentContext;
    if (navigatorContext == null || !navigatorContext.mounted) {
      return;
    }

    final widget = notification.buildDialog(navigatorContext);

    if (navigatorContext.mounted) {
      await VoicesDialog.show<void>(
        context: navigatorContext,
        routeSettings: RouteSettings(name: '/dialog-${notification.id}'),
        builder: (context) => widget,
      );
    }
  }
}
