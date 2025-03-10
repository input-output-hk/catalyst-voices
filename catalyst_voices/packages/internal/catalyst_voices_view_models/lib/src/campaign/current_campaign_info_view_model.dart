import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class CurrentCampaignInfoViewModel extends Equatable {
  final String title;
  final String description;
  final int allFunds;
  final int totalAsk;
  final List<CampaignTimelineViewModel> timeline;
  final Range<int> askRange;

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
      allFunds: 50000000,
      totalAsk: 4020000,
      askRange: Range(min: 30000, max: 150000),
    );
  }

  factory CurrentCampaignInfoViewModel.fromModel(CurrentCampaign model) {
    return CurrentCampaignInfoViewModel(
      title: model.name,
      description: model.description,
      allFunds: model.allFunds,
      totalAsk: model.totalAsk,
      askRange: model.askRange,
      timeline:
          model.timeline.map(CampaignTimelineViewModel.fromModel).toList(),
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
    super.allFunds = 50000000,
    super.totalAsk = 4020000,
    super.askRange = const Range(min: 30000, max: 150000),
    super.timeline = const [],
  });
}
