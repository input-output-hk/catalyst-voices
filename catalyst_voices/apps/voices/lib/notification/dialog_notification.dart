part of 'catalyst_notification.dart';

abstract base class DialogNotification extends CatalystNotification {
  const DialogNotification({
    super.id = 'dialogNotificationId',
    super.priority,
    super.routerPredicate,
    super.type,
  });

  Widget dialog(BuildContext context);
}
