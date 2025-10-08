part of 'catalyst_notification.dart';

abstract base class BannerNotification extends CatalystNotification {
  const BannerNotification({
    required super.id,
    super.priority,
    super.type,
    super.routerPredicate,
  });

  BannerNotificationMessage message(BuildContext context);

  String title(BuildContext context);
}
