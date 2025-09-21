import 'dart:async';

import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/notification/banner_close_button.dart';
import 'package:catalyst_voices/notification/banner_content.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

final _logger = Logger('CatalystMessenger');

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
  final _queue = PriorityQueue<CatalystNotification>();
  bool _isShowing = false;

  void add(CatalystNotification notification) {
    _logger.finest('Adding $notification to queue');
    _queue.add(notification);

    _processQueue();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onNotificationCompleted(CatalystNotification notification) {
    _logger.finer('Completed $notification');

    _isShowing = false;
    _processQueue();
  }

  void _processQueue() {
    if (_queue.isEmpty || _isShowing) {
      return;
    }

    _isShowing = true;

    final notification = _queue.removeFirst();

    _logger.finer('Showing $notification');

    final future = switch (notification) {
      BannerNotification() => _showBanner(notification),
      SnackBarNotification() => _showSnackBar(notification),
    };

    unawaited(future.whenComplete(() => _onNotificationCompleted(notification)));
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
      (value) {
        print('Banner close reason -> $value');
      },
    );
  }

  Future<void> _showSnackBar(SnackBarNotification notification) async {
    final messengerState = AppContent.scaffoldMessengerKey.currentState;
    if (messengerState == null) {
      return;
    }

    const snackbar = SnackBar(content: Text('Testing'));
    final controller = messengerState.showSnackBar(snackbar);

    return controller.closed.then(
      (value) {
        print('SnackBar close reason -> $value');
      },
    );
  }
}
