import 'package:catalyst_voices_models/src/config/app_environment.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_app_environment_type_setting.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_type.dart';

abstract class Features {
  static const votingEnvKey = 'FEATURE_VOTING';

  static const voting = Feature(
    type: FeatureType.voting,
    description: 'Enable voting functionality',
    appEnvSettings: {
      AppEnvironmentType.dev: FeatureAppEnvironmentTypeSetting(
        available: true,
        enabledByDefault: true,
      ),
    },
  );

  /// List of all features
  static const allFeatures = <Feature>[voting];

  Features._();
}
