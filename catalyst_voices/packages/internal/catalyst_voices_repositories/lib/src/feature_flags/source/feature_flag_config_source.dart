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
  bool? getValue(FeatureFlag featureFlag) => _config[featureFlag.type];

  @override
  void setValue(
    FeatureFlag featureFlag, {
    required bool? value,
  }) {
    throw ArgumentError('Cannot set value for Config feature flags at runtime.');
  }
}
