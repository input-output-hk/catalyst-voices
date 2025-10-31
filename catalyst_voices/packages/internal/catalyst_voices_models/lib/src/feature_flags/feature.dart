import 'package:catalyst_voices_models/src/config/app_environment.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_app_environment_type_setting.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_type.dart';
import 'package:equatable/equatable.dart';

final class Feature extends Equatable {
  final FeatureType type;
  final String description;
  final Map<AppEnvironmentType, FeatureAppEnvironmentTypeSetting> appEnvSettings;

  const Feature({
    required this.type,
    required this.description,
    required this.appEnvSettings,
  });

  Feature.allEnvironments({
    required this.type,
    required this.description,
    bool enabledByDefault = false,
  }) : appEnvSettings = {
         for (final e in AppEnvironmentType.values)
           e: FeatureAppEnvironmentTypeSetting(
             available: true,
             enabledByDefault: enabledByDefault,
           ),
       };

  Feature.fullyEnabled({
    required this.type,
    required this.description,
  }) : appEnvSettings = {
         for (final e in AppEnvironmentType.values)
           e: const FeatureAppEnvironmentTypeSetting(
             available: true,
             enabledByDefault: true,
           ),
       };

  @override
  List<Object?> get props => [
    type,
    description,
    appEnvSettings,
  ];

  FeatureAppEnvironmentTypeSetting getEnvironmentSetting(AppEnvironmentType type) {
    return appEnvSettings[type] ?? const FeatureAppEnvironmentTypeSetting();
  }
}
