part of 'feature_flag_source.dart';

/// Backend configuration from API
final class FeatureFlagConfigSource with FeatureFlagSourceCompareTo implements FeatureFlagSource {
  final Map<String, bool> _config;

  // TODO(bstolinski): implement load()
  // ignore: unused_field
  final AppConfig _appConfig;

  FeatureFlagConfigSource(this._appConfig) : _config = {};

  @override
  FeatureFlagSourcePriority get sourcePriority => FeatureFlagSourcePriority.config;

  @override
  bool? getValue(Feature feature) => _config[feature.name];

  @override
  void load() {
    // TODO(bstolinski): implement
  }
}
