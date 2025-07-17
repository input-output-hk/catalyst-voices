import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class CurrentCampaignInfoViewModel extends Equatable {
  final String title;
  final String description;
  final Coin allFunds;
  final Coin totalAsk;
  final List<CampaignTimelineViewModel> timeline;

  const CurrentCampaignInfoViewModel({
    required this.title,
    required this.description,
    required this.allFunds,
    required this.totalAsk,
    this.timeline = const [],
  });

  factory CurrentCampaignInfoViewModel.dummy() {
    return const CurrentCampaignInfoViewModel(
      title: 'Catalyst Fund14',
      // Description is used in dialog detail campaign
      description: '',
      allFunds: Coin.fromWholeAda(50000000),
      totalAsk: Coin.fromWholeAda(4020000),
    );
  }

  factory CurrentCampaignInfoViewModel.fromModel(CampaignDetail model) {
    return CurrentCampaignInfoViewModel(
      title: model.name,
      description: model.description,
      allFunds: model.allFunds,
      totalAsk: model.totalAsk,
      timeline: model.timeline.phases
          .map(
            (e) => CampaignTimelineViewModel.fromModel(
              e,
              offstage: e.type == CampaignPhaseType.reviewRegistration,
            ),
          )
          .toList(),
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
    super.description = '',
    super.allFunds = const Coin.fromWholeAda(50000000),
    super.totalAsk = const Coin.fromWholeAda(4020000),
    super.timeline = const [],
  });
}
