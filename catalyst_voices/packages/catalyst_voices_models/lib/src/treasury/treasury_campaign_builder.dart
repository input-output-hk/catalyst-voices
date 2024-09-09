import 'package:catalyst_voices_models/src/treasury/treasury_campaign_segment.dart';
import 'package:equatable/equatable.dart';

final class TreasuryCampaignBuilder extends Equatable {
  TreasuryCampaignBuilder({
    required this.segments,
  });

  final List<TreasuryCampaignSegment> segments;

  @override
  List<Object?> get props => [
        segments,
      ];
}
