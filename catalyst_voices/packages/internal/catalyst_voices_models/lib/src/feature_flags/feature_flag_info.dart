import 'package:catalyst_voices_models/src/feature_flags/feature.dart';
import 'package:catalyst_voices_models/src/feature_flags/feature_flag_source_type.dart';
import 'package:equatable/equatable.dart';

/// Information about a feature flag's current state
final class FeatureFlagInfo extends Equatable {
  final Feature feature;

  /// Whether the feature flag is enabled. `false` when the feature flag unavailable ([isAvailable] == `false`) for
  /// the current environment.
  final bool enabled;

  /// The source of the feature flag's current state.
  final FeatureFlagSourceType sourceType;

  /// Whether the feature is available for the current environment.
  final bool isAvailable;

  const FeatureFlagInfo({
    required this.feature,
    required this.enabled,
    required this.sourceType,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
    feature,
    enabled,
    sourceType,
    isAvailable,
  ];
}
