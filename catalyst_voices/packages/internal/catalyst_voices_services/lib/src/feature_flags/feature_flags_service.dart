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

  /// Get detailed information about a feature flag
  FeatureFlagInfo getInfo(FeatureFlag featureFlag);

  /// Get user override value for a feature flag (null if not overridden)
  bool? getUserOverride(FeatureFlag featureFlag);

  /// Check if a feature flag is available
  bool isAvailable(FeatureFlag featureFlag);

  /// Check if a feature flag is enabled
  bool isEnabled(FeatureFlag featureFlag);

  /// Set a user override feature flag and notify listeners
  void setUserOverride(
    FeatureFlag featureFlag, {
    required bool? value,
  });

  /// Watch changes for a specific feature flag
  Stream<bool> watchFeatureFlag(FeatureFlag featureFlag);
}

final class FeatureFlagsServiceImpl implements FeatureFlagsService {
  final FeatureFlagsRepository _featureFlagsRepository;

  final _changeController = StreamController<List<FeatureFlagInfo>>.broadcast();

  FeatureFlagsServiceImpl(this._featureFlagsRepository);

  @override
  Stream<List<FeatureFlagInfo>> get allInfoChanges async* {
    yield getAllInfo();
    yield* _changeController.stream;
  }

  @override
  Future<void> dispose() async {
    await _changeController.close();
  }

  @override
  List<FeatureFlagInfo> getAllInfo() {
    return _featureFlagsRepository.getAllInfo();
  }

  @override
  FeatureFlagInfo getInfo(FeatureFlag featureFlag) {
    return _featureFlagsRepository.getInfo(featureFlag);
  }

  @override
  bool? getUserOverride(FeatureFlag featureFlag) {
    return _featureFlagsRepository.getSourceValue(
      featureFlag,
      sourceType: FeatureFlagSourceType.userOverride,
    );
  }

  @override
  bool isAvailable(FeatureFlag featureFlag) {
    return _featureFlagsRepository.isAvailable(featureFlag);
  }

  @override
  bool isEnabled(FeatureFlag featureFlag) {
    return _featureFlagsRepository.isEnabled(featureFlag);
  }

  @override
  void setUserOverride(
    FeatureFlag featureFlag, {
    required bool? value,
  }) {
    _featureFlagsRepository.setValue(
      sourceType: FeatureFlagSourceType.userOverride,
      featureFlag: featureFlag,
      value: value,
    );
    _emitAllFeatures();
  }

  @override
  Stream<bool> watchFeatureFlag(FeatureFlag featureFlag) async* {
    yield isEnabled(featureFlag);
    yield* _changeController.stream.map((allFeatures) {
      return allFeatures.firstWhere((info) => info.featureFlag.type == featureFlag.type).enabled;
    }).distinct();
  }

  /// Emit current state of all features
  void _emitAllFeatures() {
    final allInfo = getAllInfo();
    _changeController.add(allInfo);
  }
}
