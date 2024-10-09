import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/widgets.dart';

/// A generic exception when we can't establish what went wrong.
final class LocalizedUnknownException extends LocalizedException {
  const LocalizedUnknownException();

  @override
  String message(BuildContext context) => context.l10n.somethingWentWrong;
}
