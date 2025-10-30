import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class FeatureFlagsService {
  factory FeatureFlagsService(
    FeatureFlagsRepository featureFlagsRepository,
  ) = FeatureFlagsServiceImpl;

  /// Stream of all feature flags state
  Stream<List<FeatureFlagInfo>> get allInfoChanges;

  /// Clean up resources
  Future<void> dispose();

  /// Get info for all features
  List<FeatureFlagInfo> getAllInfo();

  /// Get detailed information about a feature
  FeatureFlagInfo getInfo(Feature feature);

  /// Check if a feature is enabled
  bool isEnabled(Feature feature);

  /// Set a user override feature and notify listeners
  void setUserOverride(
    Feature feature, {
    required bool? value,
  });

  /// Watch changes for a specific feature
  Stream<bool> watchFeature(Feature feature);
}

final class FeatureFlagsServiceImpl implements FeatureFlagsService {
  final FeatureFlagsRepository _featureFlagsRepository;

  final _changeController = StreamController<List<FeatureFlagInfo>>.broadcast();

  FeatureFlagsServiceImpl(this._featureFlagsRepository) {
    _emitAllFeatures();
  }

  @override
  Stream<List<FeatureFlagInfo>> get allInfoChanges => _changeController.stream;

  @override
  Future<void> dispose() async {
    await _changeController.close();
  }

  @override
  List<FeatureFlagInfo> getAllInfo() {
    return _featureFlagsRepository.getAllInfo();
  }

  @override
  FeatureFlagInfo getInfo(Feature feature) {
    return _featureFlagsRepository.getInfo(feature);
  }

  @override
  bool isEnabled(Feature feature) {
    return _featureFlagsRepository.isEnabled(feature);
  }

  @override
  void setUserOverride(
    Feature feature, {
    required bool? value,
  }) {
    _featureFlagsRepository.setValue(
      sourceType: FeatureFlagSourceType.userOverride,
      feature: feature,
      value: value,
    );
    _emitAllFeatures();
  }

  @override
  Stream<bool> watchFeature(Feature feature) {
    return _changeController.stream.map((allFeatures) {
      return allFeatures.firstWhere((info) => info.featureType == feature.type).enabled;
    }).distinct();
  }

  /// Emit current state of all features
  void _emitAllFeatures() {
    final allInfo = getAllInfo();
    _changeController.add(allInfo);
  }
}
