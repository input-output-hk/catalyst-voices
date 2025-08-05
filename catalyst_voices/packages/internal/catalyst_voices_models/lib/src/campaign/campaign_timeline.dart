import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Representation of campaign timeline.
///
/// Defines timeline of different stages for [Campaign].
final class CampaignTimeline extends Equatable {
  final List<CampaignPhase> phases;

  const CampaignTimeline({required this.phases});

  @override
  List<Object?> get props => [phases];

  CampaignPhase? phase(CampaignPhaseType type) {
    return phases.firstWhereOrNull((phase) => phase.type == type);
  }
}
