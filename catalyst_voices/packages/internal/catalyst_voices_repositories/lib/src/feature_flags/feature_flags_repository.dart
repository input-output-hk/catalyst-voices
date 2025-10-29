import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/feature_flags/source/feature_flag_source.dart';
import 'package:collection/collection.dart';

/// Repository for managing feature flags from multiple sources
abstract interface class FeatureFlagsRepository {
  factory FeatureFlagsRepository(
    List<FeatureFlagSource> sources,
  ) = FeatureFlagsRepositoryImpl;

  /// Get info for all features
  List<FeatureFlagInfo> getAllInfo();

  /// Get detailed info about a feature (with highest priority source)
  FeatureFlagInfo getInfo(Feature feature);

  /// Get a specific feature flag source by type
  T? getSource<T extends FeatureFlagSource>();

  /// Get value for a feature from sources (with highest priority source)
  bool? getValue(Feature feature);

  /// Reload a specific feature flag source by type
  void reloadSource<T extends FeatureFlagSource>();
}

final class FeatureFlagsRepositoryImpl implements FeatureFlagsRepository {
  final List<FeatureFlagSource> _sources;

  FeatureFlagsRepositoryImpl(List<FeatureFlagSource> sources)
    : _sources = List.from(sources)..sort() {
    _loadAllSources();
  }

  @override
  List<FeatureFlagInfo> getAllInfo() {
    return Features.allFeatures.map(getInfo).toList();
  }

  @override
  FeatureFlagInfo getInfo(Feature feature) {
    for (final source in _sources) {
      final value = source.getValue(feature);
      if (value != null) {
        return FeatureFlagInfo(
          feature: feature,
          enabled: value,
          source: source.sourcePriority,
        );
      }
    }
    return FeatureFlagInfo(
      feature: feature,
      enabled: feature.defaultValue,
      source: FeatureFlagSourcePriority.defaults,
    );
  }

  @override
  T? getSource<T extends FeatureFlagSource>() {
    return _sources.whereType<T>().firstOrNull;
  }

  @override
  bool? getValue(Feature feature) {
    for (final source in _sources) {
      final value = source.getValue(feature);
      if (value != null) return value;
    }
    return null;
  }

  @override
  void reloadSource<T extends FeatureFlagSource>() {
    final source = getSource<T>();
    if (source != null) {
      source.load();
    }
  }

  /// Load all feature flag sources
  void _loadAllSources() {
    for (final source in _sources) {
      source.load();
    }
  }
}
