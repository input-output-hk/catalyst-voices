import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/campaign/campaign_timeline.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class CurrentCampaign extends Equatable {
  final String id;
  final String name;
  final String description;
  final Coin allFunds;
  final Coin totalAsk;
  final ComparableRange<Coin> askRange;
  final List<CampaignTimeline> timeline;

  const CurrentCampaign({
    required this.id,
    required this.name,
    required this.description,
    required this.allFunds,
    required this.totalAsk,
    required this.askRange,
    this.timeline = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        allFunds,
        totalAsk,
        askRange,
        timeline,
      ];

  CurrentCampaign copyWith({
    String? id,
    String? name,
    String? description,
    Coin? allFunds,
    Coin? totalAsk,
    ComparableRange<Coin>? askRange,
    List<CampaignTimeline>? timeline,
  }) {
    return CurrentCampaign(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      allFunds: allFunds ?? this.allFunds,
      totalAsk: totalAsk ?? this.totalAsk,
      askRange: askRange ?? this.askRange,
      timeline: timeline ?? this.timeline,
    );
  }
}

extension CurrentCampaignX on CurrentCampaign {
  static CurrentCampaign staticContent = CurrentCampaign(
    id: 'F14',
    name: 'Catalyst Fund14',
    description: '''
Project Catalyst turns economic power into innovation power by using the Cardano Treasury to incentivize and fund community-approved ideas.''',
    allFunds: const Coin.fromWholeAda(50000000),
    totalAsk: const Coin.fromWholeAda(4020000),
    askRange: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(150000),
    ),
    timeline: CampaignTimelineX.staticContent,
  );
}
