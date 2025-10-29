part of 'feature_flag_source.dart';

/// User overrides e.g. from devtools (highest priority)
final class FeatureFlagUserOverrideSource
    with FeatureFlagSourceCompareTo
    implements FeatureFlagSource {
  final Map<String, bool> _values;

  FeatureFlagUserOverrideSource() : _values = {};

  @override
  FeatureFlagSourcePriority get sourcePriority => FeatureFlagSourcePriority.userOverride;

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
