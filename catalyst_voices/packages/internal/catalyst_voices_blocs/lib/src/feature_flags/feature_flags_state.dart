import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class FeatureFlagsState extends Equatable {
  final Map<String, FeatureFlagInfo> features;

  const FeatureFlagsState({
    required this.features,
  });

  @override
  List<Object?> get props => [features];

  FeatureFlagsState copyWith({
    Map<String, FeatureFlagInfo>? features,
  }) {
    return FeatureFlagsState(
      features: features ?? this.features,
    );
  }

  /// Get info for a specific feature
  FeatureFlagInfo? getFeature(Feature feature) {
    return features[feature.name];
  }

  /// Check if a feature is enabled
  bool isEnabled(Feature feature) {
    return features[feature.name]?.enabled ?? feature.defaultValue;
  }
}
