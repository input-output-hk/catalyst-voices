import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(CatalystNotification, () {
    test('BannerNotification compareTo sorts by priority', () {
      const lowPriority = _TestBannerNotification(
        id: 'id',
        message: 'message',
        priority: 1,
      );
      const highPriority = _TestBannerNotification(
        id: 'id',
        message: 'message',
        priority: 10,
      );

      expect(lowPriority.compareTo(highPriority), lessThan(0));
      expect(highPriority.compareTo(lowPriority), greaterThan(0));
    });

    test('BannerNotification equality based on id, priority, and type', () {
      final notification1 = _TestBannerNotification(
        id: 'id',
        priority: 1,
        type: CatalystNotificationType.warning,
        routerPredicate: (state) => true,
        title: 'title 1',
        message: 'message 1',
      );
      final notification2 = _TestBannerNotification(
        id: 'id',
        priority: 1,
        type: CatalystNotificationType.warning,
        routerPredicate: (state) => false,
        title: 'title 2',
        message: 'message 2',
      );
      final notification3 = _TestBannerNotification(
        id: 'id3',
        priority: 3,
        type: CatalystNotificationType.error,
        routerPredicate: (state) => false,
        title: 'title 3',
        message: 'message 3',
      );

      expect(notification1, equals(notification2));
      expect(notification1, isNot(equals(notification3)));
    });
  });
}

final class _TestBannerNotification extends BannerNotification {
  final String _title;
  final String _message;

  const _TestBannerNotification({
    required super.id,
    super.priority,
    super.type,
    super.routerPredicate,
    String title = 'Test Title',
    String message = 'Test Message',
  }) : _title = title,
       _message = message;

  @override
  BannerNotificationMessage message(BuildContext context) {
    return BannerNotificationMessage(text: _message);
  }

  @override
  String title(BuildContext context) => _title;
}
