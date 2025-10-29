part of 'feature_flag_source.dart';

/// Dynamic runtime configuration (e.g., from documents)
final class FeatureFlagRuntimeSource with FeatureFlagSourceCompareTo implements FeatureFlagSource {
  final Map<String, bool> _values;

  FeatureFlagRuntimeSource() : _values = {};

  @override
  FeatureFlagSourcePriority get sourcePriority => FeatureFlagSourcePriority.runtimeSource;

  @override
  bool? getValue(Feature feature) => _values[feature.name];

  @override
  void load() {}

  void setValue(
    Feature feature, {
    required bool? value,
  }) {
    if (value == null) {
      _values.remove(feature.name);
    } else {
      _values[feature.name] = value;
    }
  }
}
