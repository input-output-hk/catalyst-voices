import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SessionSettings extends Equatable {
  static const _defaultTimezone = TimezonePreferences.local;
  static const _defaultTheme = ThemePreferences.light;
  static const _defaultShowSubmittionClosingWarning = true;

  final TimezonePreferences timezone;
  final ThemePreferences theme;
  final bool showSubmittionClosingWarning;

  const SessionSettings({
    required this.timezone,
    required this.theme,
    required this.showSubmittionClosingWarning,
  });

  const SessionSettings.fallback()
      : this(
          timezone: _defaultTimezone,
          theme: _defaultTheme,
          showSubmittionClosingWarning: _defaultShowSubmittionClosingWarning,
        );

  SessionSettings.fromUser(UserSettings settings)
      : this(
          timezone: settings.timezone ?? _defaultTimezone,
          theme: settings.theme ?? _defaultTheme,
          showSubmittionClosingWarning:
              settings.showSubmittionClosingWarrning ??
                  _defaultShowSubmittionClosingWarning,
        );

  @override
  List<Object?> get props => [
        timezone,
        theme,
        showSubmittionClosingWarning,
      ];
}
