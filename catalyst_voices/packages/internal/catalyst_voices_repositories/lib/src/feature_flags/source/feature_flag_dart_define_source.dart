part of 'feature_flag_source.dart';

/// Compile-time flags from --dart-define
final class FeatureFlagDartDefineSource
    with FeatureFlagSourceCompareTo
    implements FeatureFlagSource {
  final Map<String, bool> _defines;

  FeatureFlagDartDefineSource() : _defines = {};

  @override
  FeatureFlagSourcePriority get sourcePriority => FeatureFlagSourcePriority.dartDefine;

  @override
  bool? getValue(Feature feature) => _defines[feature.name];

  @override
  void load() => _initialize();

  bool? _getEnvironmentValue(String featureName) {
    switch (featureName) {
      case 'voting':
        const envKey = 'FEATURE_VOTING';
        return const bool.hasEnvironment(envKey) ? const bool.fromEnvironment(envKey) : null;
      default:
        return null;
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
