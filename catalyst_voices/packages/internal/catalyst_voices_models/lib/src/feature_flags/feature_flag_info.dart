import 'package:catalyst_voices_models/src/feature_flags/feature.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_flag_source_priority.dart';
import 'package:equatable/equatable.dart';

/// Information about a feature flag's current state
final class FeatureFlagInfo extends Equatable {
  final Feature feature;
  final bool enabled;
  final FeatureFlagSourcePriority source;

  const FeatureFlagInfo({
    required this.feature,
    required this.enabled,
    required this.source,
  });

  @override
  List<Object?> get props => [feature, enabled, source];
}
