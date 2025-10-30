import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class FeatureFlagsState extends Equatable {
  final AppEnvironmentType _environmentType;
  final Map<FeatureType, FeatureFlagInfo> features;

  const FeatureFlagsState(
    this._environmentType, {
    required this.features,
  });

  @override
  List<Object?> get props => [features];

  FeatureFlagsState copyWith({
    Map<FeatureType, FeatureFlagInfo>? features,
  }) {
    return FeatureFlagsState(
      _environmentType,
      features: features ?? this.features,
    );
  }

  FeatureFlagInfo getFeatureFlagInfo(Feature feature) {
    final featureFlagInfo = features[feature.type];
    if (featureFlagInfo != null) {
      return featureFlagInfo;
    }

    final environmentSetting = feature.getEnvironmentSetting(_environmentType);
    return FeatureFlagInfo(
      featureType: feature.type,
      enabled: environmentSetting.available && environmentSetting.enabledByDefault,
      sourceType: FeatureFlagSourceType.defaults,
    );
  }

  bool isEnabled(Feature feature) {
    return getFeatureFlagInfo(feature).enabled;
  }
}
