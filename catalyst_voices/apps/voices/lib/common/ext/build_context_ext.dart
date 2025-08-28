import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

extension BuildContextThemeExt on BuildContext {
  VoicesColorScheme get colors => theme.colors;
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  ThemeData get theme => Theme.of(this);
}
