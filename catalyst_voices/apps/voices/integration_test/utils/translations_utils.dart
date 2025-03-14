import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/material.dart';

Future<VoicesLocalizations> t() async {
  // TODO(oldgreg): we can add getting locale from a file or a system variable
  //  after we will support multiple languages, for now we only support 'en'
  const locale = 'en';
  return VoicesLocalizations.delegate.load(const Locale(locale));
}

class T {
  static String get(String key, {String? locale}) {
    return key;
  }
}
