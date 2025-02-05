import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class UserSettings extends Equatable {
  final TimezonePreferences? timezone;
  final ThemePreferences? theme;

  const UserSettings({
    this.timezone,
    this.theme,
  });

  UserSettings copyWith({
    Optional<TimezonePreferences>? timezone,
    Optional<ThemePreferences>? theme,
  }) {
    return UserSettings(
      timezone: timezone.dataOr(this.timezone),
      theme: theme.dataOr(this.theme),
    );
  }

  @override
  List<Object?> get props => [
        timezone,
        theme,
      ];
}
