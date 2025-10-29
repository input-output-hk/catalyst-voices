import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:collection/collection.dart';

abstract interface class FeatureFlagsService {
  factory FeatureFlagsService(
    FeatureFlagsRepository featureFlagsRepository,
  ) = FeatureFlagsServiceImpl;

  /// Stream of all feature flags state
  Stream<List<FeatureFlagInfo>> get changes;

  /// Clean up resources
  Future<void> dispose();

  /// Get info for all features
  List<FeatureFlagInfo> getAllInfo();

  /// Get detailed information about a feature
  FeatureFlagInfo getInfo(Feature feature);

  /// Check if a feature is enabled
  bool isEnabled(Feature feature);

  /// Set a user override feature flag and notify listeners
  void setUserOverrideFeature(
    Feature feature, {
    required bool? value,
  });

  /// Watch changes for a specific feature
  /// Extracts and emits only the requested feature's state from the global list
  Stream<bool> watchFeature(Feature feature);
}

final class FeatureFlagsServiceImpl implements FeatureFlagsService {
  final FeatureFlagsRepository _featureFlagsRepository;

  final _changeController = StreamController<List<FeatureFlagInfo>>.broadcast();

  FeatureFlagsServiceImpl(this._featureFlagsRepository) {
    _emitAllFeatures();
  }

  @override
  Stream<List<FeatureFlagInfo>> get changes => _changeController.stream;

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
    final value = _featureFlagsRepository.getValue(feature);
    return value ?? feature.defaultValue;
  }

  @override
  void setUserOverrideFeature(
    Feature feature, {
    required bool? value,
  }) {
    final userOverride = _featureFlagsRepository.getSource<FeatureFlagUserOverrideSource>();
    if (userOverride != null) {
      userOverride.setValue(feature, value: value);
      _emitAllFeatures();
    }
  }

  @override
  Stream<bool> watchFeature(Feature feature) {
    return _changeController.stream.map((allFeatures) {
      final info = allFeatures.firstWhereOrNull((info) => info.feature.name == feature.name);
      return info?.enabled ?? feature.defaultValue;
    }).distinct();
  }

  /// Emit current state of all features
  void _emitAllFeatures() {
    final allInfo = Features.allFeatures.map(getInfo).toList();
    _changeController.add(allInfo);
  }
}
