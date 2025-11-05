import 'package:catalyst_voices_models/src/feature_flags/feature_flag.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_type.dart';

abstract class Features {
  static const votingEnvKey = 'FEATURE_VOTING';

  static final voting = FeatureFlag.fullyEnabled(
    type: FeatureType.voting,
    description: 'Enable voting functionality',
  );

  /// List of all feature flags
  static final allFeatureFlags = <FeatureFlag>[voting];

  Features._();
}
