import 'package:catalyst_voices_models/catalyst_voices_models.dart';

part 'feature_flag_config_source.dart';
part 'feature_flag_dart_define_source.dart';
part 'feature_flag_runtime_source.dart';
part 'feature_flag_user_override_source.dart';

/// Base interface for all feature flag sources
abstract interface class FeatureFlagSource implements Comparable<FeatureFlagSource> {
  FeatureFlagSourceType get sourceType;

  @override
  int compareTo(FeatureFlagSource other);

  bool? getValue(FeatureFlag featureFlag);

  void setValue(
    FeatureFlag featureFlag, {
    required bool? value,
  });
}

mixin FeatureFlagSourceCompareTo implements FeatureFlagSource {
  @override
  int compareTo(FeatureFlagSource other) =>
      other.sourceType.priority.compareTo(sourceType.priority);
}
