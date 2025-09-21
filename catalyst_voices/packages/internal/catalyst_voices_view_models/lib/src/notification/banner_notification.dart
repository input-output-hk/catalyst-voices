part of 'catalyst_notification.dart';

abstract base class BannerNotification extends CatalystNotification {
  const BannerNotification({
    required super.id,
    super.priority,
    super.type,
  });

  BannerNotificationMessage message(BuildContext context);

  String title(BuildContext context);
}

final class MyAccountBannerNotification extends BannerNotification {
  MyAccountBannerNotification()
    : super(
        id: const Uuid().v4(),
        type: CatalystNotificationType.warning,
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
          onTap: (context) {
            print('Tapping my account');
          },
        ),
      },
    );
  }

  @override
  String title(BuildContext context) {
    return 'Email Not Verified';
  }
}
