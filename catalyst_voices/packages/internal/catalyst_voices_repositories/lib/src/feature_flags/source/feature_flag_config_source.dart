part of 'feature_flag_source.dart';

/// Backend configuration from API
final class FeatureFlagConfigSource with FeatureFlagSourceCompareTo implements FeatureFlagSource {
  final Map<FeatureType, bool> _config;

  // TODO(bstolinski): extract from appConfig values for feature flags
  // ignore: avoid_unused_constructor_parameters
  FeatureFlagConfigSource(AppConfig appConfig) : _config = {};

  @override
  FeatureFlagSourceType get sourceType => FeatureFlagSourceType.config;

  @override
  bool? getValue(Feature feature) => _config[feature.type];

  @override
  void setValue(
    Feature feature, {
    required bool? value,
  }) {
    throw ArgumentError('Cannot set value for Config feature flags at runtime.');
  }
}
