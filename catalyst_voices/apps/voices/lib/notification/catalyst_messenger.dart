import 'dart:async';

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
  bool _isShowingBanner = false;
  BannerNotification? _activeBanner;

  GoRouter? __router;

  GoRouter get _router {
    return __router ??= _findRouter()..routerDelegate.addListener(_handleRouterChange);
  }

  /// Adds a notification to the queue if it is not already present.
  ///
  /// This method ensures that duplicate notifications are not added to the queue.
  /// If the notification already exists in the `_pending` queue, it logs a message
  /// and skips adding it. Otherwise, the notification is added to the queue in a
  /// sorted order, and the queue is processed to display notifications.
  void add(CatalystNotification notification) {
    if (_pending.contains(notification)) {
      _logger.fine('$notification already in queue, skipping add');
      return;
    }

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
    final routerState = _router.state;

    // Handle active banner
    final activeBanner = _activeBanner;
    if (activeBanner != null && !activeBanner.routerPredicate(routerState)) {
      _logger.finer('Hiding banner(${activeBanner.id}). Not valid for router state');
      _addSorted(activeBanner);
      _hideCurrentBanner();
    }

    // Process queue if there are pending notifications
    if (_pending.isNotEmpty) {
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

  void _onBannerCompleted() {
    assert(_activeBanner != null, 'Completed banner but active was null');
    final activeBanner = _activeBanner!;

    _logger.finer('Completed banner $activeBanner');

    _isShowingBanner = false;
    _activeBanner = null;

    _processQueue();
  }

  void _processQueue() {
    final routerState = _router.state;
    final allowed = _pending.where((notification) => notification.routerPredicate(routerState));

    if (allowed.isEmpty) {
      if (_pending.isNotEmpty) {
        _logger.finest('Found ${_pending.length} notification but none allow for router state');
      }
      return;
    }

    // Process banners
    if (!_isShowingBanner) {
      final banner = allowed.whereType<BannerNotification>().firstOrNull;
      if (banner != null) {
        _pending.removeWhere((element) => element.id == banner.id);
        _activeBanner = banner;
        _isShowingBanner = true;

        _logger.finer('Showing banner $banner');

        unawaited(_showBanner(banner).whenComplete(_onBannerCompleted));
      }
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

  // Future<void> _showDialog(DialogNotification notification) async {
  //   final widget = notification.dialog(context);

  //   await VoicesDialog.show<void>(
  //     context: context,
  //     routeSettings: RouteSettings(name: '/dialog-${notification.id}'),
  //     builder: (context) => widget,
  //   ).then(
  //     (_) {
  //       _logger.finest('Dialog(${notification.id}) closed');
  //     },
  //   );
  // }
}
