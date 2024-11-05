import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/widgets.dart';

extension BuildContextLocalizationExtension on BuildContext {
  VoicesLocalizations get l10n => VoicesLocalizations.of(this)!;
}
