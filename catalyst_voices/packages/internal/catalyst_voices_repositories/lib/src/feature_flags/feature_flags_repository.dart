import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/feature_flags/source/feature_flag_source.dart';
import 'package:collection/collection.dart';

/// Repository for managing feature flags
abstract interface class FeatureFlagsRepository {
  factory FeatureFlagsRepository(
    AppEnvironmentType environmentType,
    AppConfig appConfig,
  ) = FeatureFlagsRepositoryImpl;

  /// Get info for all feature flags
  List<FeatureFlagInfo> getAllInfo();

  /// Get detailed info about a feature flag (with highest priority source)
  FeatureFlagInfo getInfo(FeatureFlag featureFlag);

  /// Get value for a [featureFlag] in a specific [sourceType] (null if not set)
  bool? getSourceValue(
    FeatureFlag featureFlag, {
    required FeatureFlagSourceType sourceType,
  });

  /// Check if a feature flag is available for current environment
  bool isAvailable(FeatureFlag featureFlag);

  /// Get value for a feature flag from sources (with highest priority source)
  bool isEnabled(FeatureFlag featureFlag);

  /// Set value for a feature flag in a specific source
  /// Throws [ArgumentError] if feature flag is not available for environment or source is not found
  void setValue({
    required FeatureFlagSourceType sourceType,
    required FeatureFlag featureFlag,
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
    return Features.allFeatureFlags.map(getInfo).toList();
  }

  @override
  FeatureFlagInfo getInfo(FeatureFlag featureFlag) {
    final environmentSetting = _getEnvironmentSetting(featureFlag);
    final isAvailable = environmentSetting.available;
    if (!isAvailable) {
      return FeatureFlagInfo(
        featureFlag: featureFlag,
        enabled: false,
        sourceType: FeatureFlagSourceType.defaults,
        isAvailable: isAvailable,
      );
    }

    for (final source in _sources) {
      final value = source.getValue(featureFlag);
      if (value != null) {
        return FeatureFlagInfo(
          featureFlag: featureFlag,
          enabled: value,
          sourceType: source.sourceType,
          isAvailable: isAvailable,
        );
      }
    }

    return FeatureFlagInfo(
      featureFlag: featureFlag,
      enabled: environmentSetting.enabledByDefault,
      sourceType: FeatureFlagSourceType.defaults,
      isAvailable: isAvailable,
    );
  }

  @override
  bool? getSourceValue(
    FeatureFlag featureFlag, {
    required FeatureFlagSourceType sourceType,
  }) {
    final isAvailableForEnvironment = isAvailable(featureFlag);
    if (!isAvailableForEnvironment) {
      return false;
    }
    return _sources.firstWhereOrNull((e) => e.sourceType == sourceType)?.getValue(featureFlag);
  }

  @override
  bool isAvailable(FeatureFlag featureFlag) {
    return _getEnvironmentSetting(featureFlag).available;
  }

  @override
  bool isEnabled(FeatureFlag featureFlag) {
    return getInfo(featureFlag).enabled;
  }

  @override
  void setValue({
    required FeatureFlagSourceType sourceType,
    required FeatureFlag featureFlag,
    required bool? value,
  }) {
    final isAvailableForEnvironment = isAvailable(featureFlag);
    if (!isAvailableForEnvironment) {
      throw ArgumentError(
        'Feature $featureFlag is not available for environment $_environmentType.',
      );
    }

    final source = _sources.firstWhereOrNull((s) => s.sourceType == sourceType);
    if (source == null) {
      throw ArgumentError('No source found for type $sourceType.');
    }
    source.setValue(featureFlag, value: value);
  }

  FeatureAppEnvironmentTypeSetting _getEnvironmentSetting(FeatureFlag featureFlag) {
    return featureFlag.getEnvironmentSetting(_environmentType);
  }
}
