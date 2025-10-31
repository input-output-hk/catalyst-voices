import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/feature_flags/source/feature_flag_source.dart';
import 'package:collection/collection.dart';

/// Repository for managing feature flags
abstract interface class FeatureFlagsRepository {
  factory FeatureFlagsRepository(
    AppEnvironmentType environmentType,
    AppConfig appConfig,
  ) = FeatureFlagsRepositoryImpl;

  /// Get info for all features
  List<FeatureFlagInfo> getAllInfo();

  /// Get detailed info about a feature (with highest priority source)
  FeatureFlagInfo getInfo(Feature feature);

  /// Get value for a [feature] in a specific [sourceType] (null if not set)
  bool? getSourceValue(
    Feature feature, {
    required FeatureFlagSourceType sourceType,
  });

  /// Check if a feature is available for current environment
  bool isAvailable(Feature feature);

  /// Get value for a feature from sources (with highest priority source)
  bool isEnabled(Feature feature);

  /// Set value for a feature in a specific source
  /// Throws [ArgumentError] if feature is not available for environment or source is not found
  void setValue({
    required FeatureFlagSourceType sourceType,
    required Feature feature,
    required bool? value,
  });
}

final class FeatureFlagsRepositoryImpl implements FeatureFlagsRepository {
  final List<FeatureFlagSource> _sources;
  final AppEnvironmentType _environmentType;

  FeatureFlagsRepositoryImpl(
    this._environmentType,
    AppConfig appConfig,
  ) : _sources = [
        FeatureFlagUserOverrideSource(),
        FeatureFlagDartDefineSource(),
        FeatureFlagConfigSource(appConfig),
        FeatureFlagRuntimeSource(),
      ]..sort();

  @override
  List<FeatureFlagInfo> getAllInfo() {
    return Features.allFeatures.map(getInfo).toList();
  }

  @override
  FeatureFlagInfo getInfo(Feature feature) {
    final environmentSetting = _getEnvironmentSetting(feature);
    final isAvailable = environmentSetting.available;
    if (!isAvailable) {
      return FeatureFlagInfo(
        feature: feature,
        enabled: false,
        sourceType: FeatureFlagSourceType.defaults,
        isAvailable: isAvailable,
      );
    }

    for (final source in _sources) {
      final value = source.getValue(feature);
      if (value != null) {
        return FeatureFlagInfo(
          feature: feature,
          enabled: value,
          sourceType: source.sourceType,
          isAvailable: isAvailable,
        );
      }
    }

    return FeatureFlagInfo(
      feature: feature,
      enabled: environmentSetting.enabledByDefault,
      sourceType: FeatureFlagSourceType.defaults,
      isAvailable: isAvailable,
    );
  }

  @override
  bool? getSourceValue(
    Feature feature, {
    required FeatureFlagSourceType sourceType,
  }) {
    final isAvailableForEnvironment = isAvailable(feature);
    if (!isAvailableForEnvironment) {
      return false;
    }
    return _sources.firstWhereOrNull((e) => e.sourceType == sourceType)?.getValue(feature);
  }

  @override
  bool isAvailable(Feature feature) {
    return _getEnvironmentSetting(feature).available;
  }

  @override
  bool isEnabled(Feature feature) {
    return getInfo(feature).enabled;
  }

  @override
  void setValue({
    required FeatureFlagSourceType sourceType,
    required Feature feature,
    required bool? value,
  }) {
    final isAvailableForEnvironment = isAvailable(feature);
    if (!isAvailableForEnvironment) {
      throw ArgumentError('Feature $feature is not available for environment $_environmentType.');
    }

    final source = _sources.firstWhereOrNull((s) => s.sourceType == sourceType);
    if (source == null) {
      throw ArgumentError('No source found for type $sourceType.');
    }
    source.setValue(feature, value: value);
  }

  FeatureAppEnvironmentTypeSetting _getEnvironmentSetting(Feature feature) {
    return feature.getEnvironmentSetting(_environmentType);
  }
}
