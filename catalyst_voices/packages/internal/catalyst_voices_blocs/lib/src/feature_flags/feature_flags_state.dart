import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class FeatureFlagsState extends Equatable {
  final Map<FeatureType, FeatureFlagInfo> features;

  const FeatureFlagsState({
    required this.features,
  });

  @override
  List<Object?> get props => [features];

  FeatureFlagsState copyWith({
    Map<FeatureType, FeatureFlagInfo>? features,
  }) {
    return FeatureFlagsState(
      features: features ?? this.features,
    );
  }

  bool isEnabled(Feature feature) {
    return features[feature.type]?.enabled ?? false;
  }
}
