import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SessionSettings extends Equatable {
  static const _defaultTimezone = TimezonePreferences.local;
  static const _defaultTheme = ThemePreferences.light;
  static const _defaultShowSubmissionClosingWarning = true;

  final TimezonePreferences timezone;
  final ThemePreferences theme;
  final bool showSubmissionClosingWarning;

  const SessionSettings({
    required this.timezone,
    required this.theme,
    required this.showSubmissionClosingWarning,
  });

  const SessionSettings.fallback()
      : this(
          timezone: _defaultTimezone,
          theme: _defaultTheme,
          showSubmissionClosingWarning: _defaultShowSubmissionClosingWarning,
        );

  SessionSettings.fromUser(UserSettings settings)
      : this(
          timezone: settings.timezone ?? _defaultTimezone,
          theme: settings.theme ?? _defaultTheme,
          showSubmissionClosingWarning: settings.showSubmissionClosingWarning ??
              _defaultShowSubmissionClosingWarning,
        );

  @override
  List<Object?> get props => [
        timezone,
        theme,
        showSubmissionClosingWarning,
      ];
}
