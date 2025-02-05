import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SessionSettings extends Equatable {
  final TimezonePreferences timezone;
  final ThemePreferences theme;

  static const _defaultTimezone = TimezonePreferences.local;
  static const _defaultTheme = ThemePreferences.light;

  const SessionSettings({
    required this.timezone,
    required this.theme,
  });

  const SessionSettings.fallback()
      : this(
          timezone: _defaultTimezone,
          theme: _defaultTheme,
        );

  SessionSettings.fromUser(UserSettings settings)
      : this(
          timezone: settings.timezone ?? _defaultTimezone,
          theme: settings.theme ?? _defaultTheme,
        );

  @override
  List<Object?> get props => [timezone, theme];
}
