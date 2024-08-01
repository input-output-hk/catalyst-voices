import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';

/// A function that resolves a localized string based on a given
/// [VoicesLocalizations].
///
/// This function takes a [VoicesLocalizations] as input and returns a [String].
typedef L10nResolver = String Function(VoicesLocalizations);
