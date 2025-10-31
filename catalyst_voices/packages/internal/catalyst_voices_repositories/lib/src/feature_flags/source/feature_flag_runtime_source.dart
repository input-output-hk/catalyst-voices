part of 'feature_flag_source.dart';

/// Dynamic runtime configuration (e.g., from documents)
final class FeatureFlagRuntimeSource with FeatureFlagSourceCompareTo implements FeatureFlagSource {
  final Map<FeatureType, bool> _values;

  FeatureFlagRuntimeSource() : _values = {};

  @override
  FeatureFlagSourceType get sourceType => FeatureFlagSourceType.runtimeSource;

  @override
  bool? getValue(Feature feature) => _values[feature.type];

  @override
  void setValue(
    Feature feature, {
    required bool? value,
  }) {
    if (value == null) {
      _values.remove(feature.type);
    } else {
      _values[feature.type] = value;
    }
  }
}
