import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// View model for current campaign info.
///
/// This view model is used to display the info of a current campaign.
class CurrentCampaignInfoViewModel extends Equatable {
  final String title;
  final String description;
  final Coin allFunds;
  final Coin totalAsk;
  final List<CampaignTimelineViewModel> timeline;
  final ComparableRange<Coin> askRange;

  const CurrentCampaignInfoViewModel({
    required this.title,
    required this.description,
    required this.allFunds,
    required this.totalAsk,
    required this.askRange,
    this.timeline = const [],
  });

  factory CurrentCampaignInfoViewModel.dummy() {
    return const CurrentCampaignInfoViewModel(
      title: 'Catalyst Fund14',
      // Description is used in dialog detail campaign
      description: '',
      allFunds: Coin.fromWholeAda(50000000),
      totalAsk: Coin.fromWholeAda(4020000),
      askRange: ComparableRange(
        min: Coin.fromWholeAda(30000),
        max: Coin.fromWholeAda(150000),
      ),
    );
  }

  factory CurrentCampaignInfoViewModel.fromModel(CurrentCampaign model) {
    return CurrentCampaignInfoViewModel(
      title: model.name,
      description: model.description,
      allFunds: model.allFunds,
      totalAsk: model.totalAsk,
      askRange: model.askRange,
      timeline: model.timeline.map(CampaignTimelineViewModel.fromModel).toList(),
    );
  }

  @override
  List<Object?> get props => [
        allFunds,
        totalAsk,
        askRange,
        timeline,
      ];
}

class NullCurrentCampaignInfoViewModel extends CurrentCampaignInfoViewModel {
  const NullCurrentCampaignInfoViewModel({
    super.title = '',
    super.description = '',
    super.allFunds = const Coin.fromWholeAda(50000000),
    super.totalAsk = const Coin.fromWholeAda(4020000),
    super.askRange = const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(150000),
    ),
    super.timeline = const [],
  });
}
