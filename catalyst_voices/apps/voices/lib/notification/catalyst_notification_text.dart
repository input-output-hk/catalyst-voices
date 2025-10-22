part of 'catalyst_notification.dart';

typedef CatalystNotificationTextPartOnTap = void Function(BuildContext context);

class BannerNotificationMessage extends Equatable {
  final String text;
  final Map<String, CatalystNotificationTextPart> placeholders;

  const BannerNotificationMessage({
    required this.text,
    this.placeholders = const {},
  });

  @override
  List<Object?> get props => [text, placeholders];
}

class CatalystNotificationTextPart extends Equatable {
  final String text;
  final bool bold;
  final CatalystNotificationTextPartOnTap? onTap;

  const CatalystNotificationTextPart({
    required this.text,
    this.bold = false,
    this.onTap,
  });

  @override
  List<Object?> get props => [text, bold, onTap];

  bool get underlined => onTap != null;
}
