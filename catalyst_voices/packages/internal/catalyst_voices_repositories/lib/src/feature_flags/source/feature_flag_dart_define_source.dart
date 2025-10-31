part of 'feature_flag_source.dart';

/// Compile-time flags from --dart-define
final class FeatureFlagDartDefineSource
    with FeatureFlagSourceCompareTo
    implements FeatureFlagSource {
  final Map<FeatureType, bool> _defines;

  FeatureFlagDartDefineSource()
    : _defines = Map.fromEntries(
        Features.allFeatures.map((feature) {
          final value = _getEnvironmentValue(feature.type);
          if (value != null) {
            return MapEntry(feature.type, value);
          }
        }).nonNulls,
      );

  @override
  FeatureFlagSourceType get sourceType => FeatureFlagSourceType.dartDefine;

  @override
  bool? getValue(Feature feature) => _defines[feature.type];

  @override
  void setValue(
    Feature feature, {
    required bool? value,
  }) {
    throw ArgumentError('Cannot set value for Dart Define feature flags at runtime.');
  }

  static bool? _getEnvironmentValue(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.voting:
        return const bool.hasEnvironment(Features.votingEnvKey)
            ? const bool.fromEnvironment(Features.votingEnvKey)
            : null;
    }
  }
}
