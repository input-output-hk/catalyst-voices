import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_app_environment_type_setting.dart';

abstract class Features {
  static const votingEnvKey = 'FEATURE_VOTING';

  static const voting = FeatureFlag(
    type: FeatureType.voting,
    description: 'Enable voting functionality',
    appEnvSettings: {
      AppEnvironmentType.dev: FeatureAppEnvironmentTypeSetting(
        available: true,
        enabledByDefault: true,
      ),
    },
  );

  /// List of all feature flags
  static const allFeatureFlags = <FeatureFlag>[voting];

  Features._();
}
