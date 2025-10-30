import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/feature_flags/source/feature_flag_source.dart';
import 'package:collection/collection.dart';

/// Repository for managing feature flags from multiple sources
abstract interface class FeatureFlagsRepository {
  factory FeatureFlagsRepository(
    AppEnvironmentType environmentType,
    AppConfig appConfig,
  ) = FeatureFlagsRepositoryImpl;

  /// Get info for all features
  List<FeatureFlagInfo> getAllInfo();

  /// Get detailed info about a feature (with highest priority source)
  FeatureFlagInfo getInfo(Feature feature);

  /// Get value for a feature from sources (with highest priority source)
  bool getValue(Feature feature);

  /// Set value for a feature in a specific source
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
    final environmentSetting = feature.getEnvironmentSetting(_environmentType);
    if (!environmentSetting.available) {
      return FeatureFlagInfo(
        featureType: feature.type,
        enabled: false,
        sourceType: FeatureFlagSourceType.defaults,
      );
    }

    for (final source in _sources) {
      final value = source.getValue(feature);
      if (value != null) {
        return FeatureFlagInfo(
          featureType: feature.type,
          enabled: value,
          sourceType: source.sourceType,
        );
      }
    }

    return FeatureFlagInfo(
      featureType: feature.type,
      enabled: environmentSetting.enabledByDefault,
      sourceType: FeatureFlagSourceType.defaults,
    );
  }

  @override
  bool getValue(Feature feature) {
    return getInfo(feature).enabled;
  }

  @override
  void setValue({
    required FeatureFlagSourceType sourceType,
    required Feature feature,
    required bool? value,
  }) {
    final source = _sources.firstWhereOrNull((s) => s.sourceType == sourceType);
    if (source != null) {
      source.setValue(
        feature,
        value: value,
      );
    }
  }
}
