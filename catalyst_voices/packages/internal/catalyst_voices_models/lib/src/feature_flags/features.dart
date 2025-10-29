import 'package:catalyst_voices_models/src/feature_flags/feature.dart';

abstract class Features {
  static const voting = Feature(
    name: 'voting',
    description: 'Enable voting functionality',
  );

  /// List of all features for iteration
  static const List<Feature> allFeatures = [voting];

  Features._();
}
