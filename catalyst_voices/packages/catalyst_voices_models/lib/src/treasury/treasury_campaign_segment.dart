import 'package:catalyst_voices_models/src/treasury/treasury_campaign_segment_step.dart';
import 'package:equatable/equatable.dart';

sealed class TreasuryCampaignSegment extends Equatable {
  final Object id;
  final List<TreasuryCampaignSegmentStep> steps;

  const TreasuryCampaignSegment({
    required this.id,
    required this.steps,
  });

  @override
  List<Object?> get props => [
        id,
        steps,
      ];
}

final class TreasuryCampaignSetup extends TreasuryCampaignSegment {
  const TreasuryCampaignSetup({
    required super.id,
    required super.steps,
  });
}
