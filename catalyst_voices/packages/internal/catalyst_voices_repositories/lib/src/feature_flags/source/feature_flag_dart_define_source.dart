part of 'feature_flag_source.dart';

/// Compile-time flags from --dart-define
final class FeatureFlagDartDefineSource
    with FeatureFlagSourceCompareTo
    implements FeatureFlagSource {
  final Map<FeatureName, bool> _defines;

  FeatureFlagDartDefineSource() : _defines = {};

  @override
  FeatureFlagSourcePriority get sourcePriority => FeatureFlagSourcePriority.dartDefine;

  @override
  bool? getValue(Feature feature) => _defines[feature.name];

  @override
  void load() => _initialize();

  bool? _getEnvironmentValue(FeatureName featureName) {
    switch (featureName) {
      case FeatureName.voting:
        return const bool.hasEnvironment(Features.votingEnvKey)
            ? const bool.fromEnvironment(Features.votingEnvKey)
            : null;
    }
  }

  void _initialize() {
    for (final feature in Features.allFeatures) {
      final value = _getEnvironmentValue(feature.name);
      if (value != null) {
        _defines[feature.name] = value;
      }
    }
  }
}
