part of 'feature_flag_source.dart';

/// User overrides e.g. from devtools (highest priority)
final class FeatureFlagUserOverrideSource
    with FeatureFlagSourceCompareTo
    implements FeatureFlagSource {
  final Map<FeatureType, bool> _values;

  FeatureFlagUserOverrideSource() : _values = {};

  @override
  FeatureFlagSourceType get sourceType => FeatureFlagSourceType.userOverride;

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
