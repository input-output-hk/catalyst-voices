import 'package:catalyst_voices_models/src/campaign/campaign_phase.dart';
import 'package:equatable/equatable.dart';

final class CampaignTimeline extends Equatable {
  final List<CampaignPhase> phases;

  const CampaignTimeline({required this.phases});

  @override
  List<Object?> get props => [phases];
}
