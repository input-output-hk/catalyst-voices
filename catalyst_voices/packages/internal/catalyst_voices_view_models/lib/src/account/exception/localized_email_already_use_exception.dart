import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/widgets.dart';

/// A localized version of [EmailAlreadyUsedException].
final class LocalizedEmailAlreadyUsedException extends LocalizedException {
  const LocalizedEmailAlreadyUsedException();

  @override
  String message(BuildContext context) => context.l10n.errorEmailAlreadyInUse;
}
