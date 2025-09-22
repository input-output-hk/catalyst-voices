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

final class MyAccountBannerNotification extends BannerNotification {
  final CatalystNotificationTextPartOnTap onMyAccountTap;

  MyAccountBannerNotification({
    super.routerPredicate,
    required this.onMyAccountTap,
  }) : super(
         id: const Uuid().v4(),
         type: CatalystNotificationType.info,
       );

  @override
  BannerNotificationMessage message(BuildContext context) {
    return BannerNotificationMessage(
      text:
          'You can’t publish a proposal until your email is verified. '
          'Go to {destination} to verify it.',
      placeholders: {
        'destination': CatalystNotificationTextPart(
          text: 'My account',
          onTap: onMyAccountTap,
        ),
      },
    );
  }

  @override
  String title(BuildContext context) {
    return 'Email Not Verified';
  }
}
