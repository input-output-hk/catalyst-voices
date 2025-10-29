part of 'feature_flag_source.dart';

/// Returns feature default values (lowest priority)
final class FeatureFlagDefaultsSource with FeatureFlagSourceCompareTo implements FeatureFlagSource {
  const FeatureFlagDefaultsSource();

  @override
  FeatureFlagSourcePriority get sourcePriority => FeatureFlagSourcePriority.defaults;

  @override
  bool? getValue(Feature feature) => feature.defaultValue;

  @override
  void load() {}
}
