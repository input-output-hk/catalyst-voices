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

  /// Get value for a feature flag from sources (with highest priority source)
  bool isEnabled(FeatureFlag featureFlag);

  /// Set value for a feature flag in a specific source
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
    final environmentSetting = featureFlag.getEnvironmentSetting(_environmentType);
    if (!environmentSetting.available) {
      return FeatureFlagInfo(
        featureType: featureFlag.type,
        enabled: false,
        sourceType: FeatureFlagSourceType.defaults,
      );
    }

    for (final source in _sources) {
      final value = source.getValue(featureFlag);
      if (value != null) {
        return FeatureFlagInfo(
          featureType: featureFlag.type,
          enabled: value,
          sourceType: source.sourceType,
        );
      }
    }

    return FeatureFlagInfo(
      featureType: featureFlag.type,
      enabled: environmentSetting.enabledByDefault,
      sourceType: FeatureFlagSourceType.defaults,
    );
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
    final source = _sources.firstWhereOrNull((s) => s.sourceType == sourceType);
    if (source == null) {
      throw ArgumentError('No source found for type $sourceType.');
    }
    source.setValue(featureFlag, value: value);
  }
}
