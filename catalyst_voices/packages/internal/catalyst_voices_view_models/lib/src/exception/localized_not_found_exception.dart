import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class LocalizedNotFoundException extends LocalizedException {
  const LocalizedNotFoundException();

  @override
  String message(BuildContext context) => context.l10n.notFoundError;
}
