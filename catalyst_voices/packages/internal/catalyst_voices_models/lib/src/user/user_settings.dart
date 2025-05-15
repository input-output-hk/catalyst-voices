import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class UserSettings extends Equatable {
  final TimezonePreferences? timezone;
  final ThemePreferences? theme;
  final bool? showSubmissionClosingWarning;

  const UserSettings({
    this.timezone,
    this.theme,
    this.showSubmissionClosingWarning,
  });

  @override
  List<Object?> get props => [
        timezone,
        theme,
        showSubmissionClosingWarning,
      ];

  UserSettings copyWith({
    Optional<TimezonePreferences>? timezone,
    Optional<ThemePreferences>? theme,
    Optional<bool>? showSubmissionClosingWarning,
  }) {
    return UserSettings(
      timezone: timezone.dataOr(this.timezone),
      theme: theme.dataOr(this.theme),
      showSubmissionClosingWarning:
          showSubmissionClosingWarning.dataOr(this.showSubmissionClosingWarning),
    );
  }
}
