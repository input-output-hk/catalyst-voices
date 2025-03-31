import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class UserSettings extends Equatable {
  final TimezonePreferences? timezone;
  final ThemePreferences? theme;
  final bool? showSubmittionClosingWarrning;

  const UserSettings({
    this.timezone,
    this.theme,
    this.showSubmittionClosingWarrning,
  });

  @override
  List<Object?> get props => [
        timezone,
        theme,
        showSubmittionClosingWarrning,
      ];

  UserSettings copyWith({
    Optional<TimezonePreferences>? timezone,
    Optional<ThemePreferences>? theme,
    Optional<bool>? showSubmittionClosingWarrning,
  }) {
    return UserSettings(
      timezone: timezone.dataOr(this.timezone),
      theme: theme.dataOr(this.theme),
      showSubmittionClosingWarrning: showSubmittionClosingWarrning
          .dataOr(this.showSubmittionClosingWarrning),
    );
  }
}
