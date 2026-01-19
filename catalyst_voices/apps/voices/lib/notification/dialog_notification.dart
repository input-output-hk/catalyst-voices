part of 'catalyst_notification.dart';

abstract base class DialogNotification extends CatalystNotification {
  const DialogNotification({
    required super.id,
    super.priority,
    super.routerPredicate,
    super.type,
  });

  Widget buildDialog(BuildContext context);
}
