import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// View model for current campaign info.
///
/// This view model is used to display the info of a current campaign.
class CurrentCampaignInfoViewModel extends Equatable {
  final String title;
  final Coin allFunds;
  final Coin totalAsk;
  final List<CampaignTimelineViewModel> timeline;

  const CurrentCampaignInfoViewModel({
    required this.title,
    required this.allFunds,
    required this.totalAsk,
    this.timeline = const [],
  });

  factory CurrentCampaignInfoViewModel.dummy() {
    return const CurrentCampaignInfoViewModel(
      title: 'Catalyst Fund14',
      // Description is used in dialog detail campaign
      allFunds: Coin.fromWholeAda(50000000),
      totalAsk: Coin.fromWholeAda(4020000),
    );
  }

  factory CurrentCampaignInfoViewModel.fromModel(Campaign model) {
    return CurrentCampaignInfoViewModel(
      title: model.name,
      allFunds: model.allFunds,
      totalAsk: model.totalAsk,
      timeline: model.timeline.phases.map(CampaignTimelineViewModel.fromModel).toList(),
    );
  }

  @override
  List<Object?> get props => [
    allFunds,
    totalAsk,
    timeline,
  ];
}

class NullCurrentCampaignInfoViewModel extends CurrentCampaignInfoViewModel {
  const NullCurrentCampaignInfoViewModel({
    super.title = '',
    super.allFunds = const Coin.fromWholeAda(50000000),
    super.totalAsk = const Coin.fromWholeAda(4020000),
    super.timeline = const [],
  });
}
