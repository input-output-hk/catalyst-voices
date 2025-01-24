import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class PreferencesState extends Equatable {
  final TimezonePreferences timezone;
  final ThemePreferences theme;

  const PreferencesState({
    required this.timezone,
    required this.theme,
  });

  PreferencesState copyWith({
    TimezonePreferences? timezone,
    ThemePreferences? theme,
  }) {
    return PreferencesState(
      timezone: timezone ?? this.timezone,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [
        timezone,
        theme,
      ];
}
