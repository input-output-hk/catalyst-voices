import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/widgets.dart';

/// An exception thrown when submitting a registration transaction fails.
final class LocalizedRegistrationTransactionException
    extends LocalizedException {
  const LocalizedRegistrationTransactionException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationTransactionFailed;
}
