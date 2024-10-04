import 'package:catalyst_voices_models/src/treasury/treasury_campaign_segment.dart';
import 'package:equatable/equatable.dart';

final class TreasuryCampaignBuilder extends Equatable {
  final List<TreasuryCampaignSegment> segments;

  const TreasuryCampaignBuilder({
    required this.segments,
  });

  @override
  List<Object?> get props => [
        segments,
      ];
}
