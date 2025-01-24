import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

class CurrentCampaignInfoViewModel extends Equatable {
  final int allFunds;
  final int totalAsk;
  final Range<int> askRange;

  const CurrentCampaignInfoViewModel({
    required this.allFunds,
    required this.totalAsk,
    required this.askRange,
  });

  factory CurrentCampaignInfoViewModel.dummy() {
    return const CurrentCampaignInfoViewModel(
      allFunds: 50000000,
      totalAsk: 4020000,
      askRange: Range(min: 30000, max: 150000),
    );
  }

  @override
  List<Object?> get props => [allFunds, totalAsk, askRange];
}
