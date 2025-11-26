part of 'feature_flag_source.dart';

/// Dynamic runtime configuration (e.g., from documents)
final class FeatureFlagRuntimeSource with FeatureFlagSourceCompareTo implements FeatureFlagSource {
  final Map<FeatureType, bool> _values;

  FeatureFlagRuntimeSource() : _values = {};

  @override
  FeatureFlagSourceType get sourceType => FeatureFlagSourceType.runtimeSource;

  @override
  bool? getValue(FeatureFlag featureFlag) => _values[featureFlag.type];

  @override
  void setValue(
    FeatureFlag featureFlag, {
    required bool? value,
  }) {
    if (value == null) {
      _values.remove(featureFlag.type);
    } else {
      _values[featureFlag.type] = value;
    }
  }
}
