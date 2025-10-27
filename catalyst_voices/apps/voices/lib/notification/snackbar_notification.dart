part of 'catalyst_notification.dart';

abstract base class SnackbarNotification extends CatalystNotification {
  const SnackbarNotification({required super.id, super.priority, super.type});

  /// Returns the title text for the snackbar.
  String title(BuildContext context);

  /// Returns the message text for the snackbar.
  String message(BuildContext context);

  /// Returns a custom icon for the snackbar.
  /// If null, the default icon from [type] will be used.
  Widget? icon(BuildContext context) => null;

  /// Returns a custom duration for the snackbar.
  /// If null, the default duration (4 seconds) will be used.
  Duration? get duration => null;

  /// Whether to show the close button.
  /// Defaults to true.
  bool get showClose => true;

  /// Returns the list of action buttons for the snackbar.
  /// Defaults to an empty list.
  List<Widget> get actions => const [];

  /// Returns the behavior of the snackbar (floating or fixed).
  /// If null, defaults to floating.
  SnackBarBehavior? get behavior => SnackBarBehavior.floating;
}
