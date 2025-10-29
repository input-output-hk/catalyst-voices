import 'package:catalyst_voices_models/src/feature_flags/feature.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_name.dart';

abstract class Features {
  static const votingEnvKey = 'FEATURE_VOTING';

  static const voting = Feature(
    name: FeatureName.voting,
    description: 'Enable voting functionality',
  );

  /// List of all features
  static const List<Feature> allFeatures = [voting];

  Features._();
}
