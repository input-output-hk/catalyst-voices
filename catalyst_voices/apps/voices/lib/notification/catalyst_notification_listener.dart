import 'dart:async';

import 'package:catalyst_voices/notification/catalyst_messenger.dart';
import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:flutter/material.dart';

class CatalystNotificationListener extends StatefulWidget {
  final Widget child;

  const CatalystNotificationListener({
    super.key,
    required this.child,
  });

  @override
  State<CatalystNotificationListener> createState() => _CatalystNotificationListenerState();
}

class _CatalystNotificationListenerState extends State<CatalystNotificationListener> {
  StreamSubscription<CatalystNotification>? _sub;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _sub = null;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // _sub = Dependencies.instance.get<EventBus>().on<CatalystNotification>().listen(
    //   _addNotification,
    // );
  }

  void _addNotification(CatalystNotification notification) {
    CatalystMessenger.of(context).add(notification);
  }
}
