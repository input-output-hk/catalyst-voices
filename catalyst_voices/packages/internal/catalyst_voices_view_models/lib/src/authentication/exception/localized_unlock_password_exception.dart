import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/widgets.dart';

/// An incorrect password was used to unlock the keychain.
final class LocalizedUnlockPasswordException extends LocalizedException {
  const LocalizedUnlockPasswordException();

  @override
  String message(BuildContext context) =>
      context.l10n.unlockDialogIncorrectPassword;
}
