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
