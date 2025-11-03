import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class FeatureFlagsState extends Equatable {
  final Map<FeatureType, FeatureFlagInfo> featureFlags;

  const FeatureFlagsState({
    required this.featureFlags,
  });

  @override
  List<Object?> get props => [featureFlags];

  FeatureFlagsState copyWith({
    Map<FeatureType, FeatureFlagInfo>? featureFlags,
  }) {
    return FeatureFlagsState(
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }

  bool isEnabled(FeatureFlag featureFlag) {
    return featureFlags[featureFlag.type]?.enabled ?? false;
  }
}
