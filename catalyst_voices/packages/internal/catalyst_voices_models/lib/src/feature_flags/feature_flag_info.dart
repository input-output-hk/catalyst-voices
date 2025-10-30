import 'package:catalyst_voices_models/src/feature_flags/feature_flag_source_type.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_type.dart';
import 'package:equatable/equatable.dart';

/// Information about a feature flag's current state
final class FeatureFlagInfo extends Equatable {
  final FeatureType featureType;
  final bool enabled;
  final FeatureFlagSourceType sourceType;

  const FeatureFlagInfo({
    required this.featureType,
    required this.enabled,
    required this.sourceType,
  });

  @override
  List<Object?> get props => [featureType, enabled, sourceType];
}
