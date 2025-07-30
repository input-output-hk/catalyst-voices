import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

/// Exception thrown when an active account cannot be found, with localization support.
///
/// This exception is used to indicate that the application was unable to find an active account
/// and provides a localized error message for display in the UI.
final class LocalizedActiveAccountNotFoundException extends LocalizedException {
  const LocalizedActiveAccountNotFoundException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorActiveAccountNotFound;
  }
}
