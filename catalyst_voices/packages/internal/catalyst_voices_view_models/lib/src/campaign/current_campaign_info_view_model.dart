import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// View model for current campaign info.
///
/// This view model is used to display the info of a current campaign.
class CurrentCampaignInfoViewModel extends Equatable {
  final String title;
  final MultiCurrencyAmount allFunds;
  final MultiCurrencyAmount totalAsk;
  final List<CampaignTimelineViewModel> timeline;

  const CurrentCampaignInfoViewModel({
    required this.title,
    required this.allFunds,
    required this.totalAsk,
    this.timeline = const [],
  });

  factory CurrentCampaignInfoViewModel.dummy() {
    return CurrentCampaignInfoViewModel(
      title: 'Catalyst Fund14',
      allFunds: MultiCurrencyAmount.single(
        Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(50000000),
        ),
      ),
      totalAsk: MultiCurrencyAmount.single(
        Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(4020000),
        ),
      ),
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
  factory NullCurrentCampaignInfoViewModel({
    String? title,
    MultiCurrencyAmount? allFunds,
    MultiCurrencyAmount? totalAsk,
    List<CampaignTimelineViewModel>? timeline,
  }) {
    return NullCurrentCampaignInfoViewModel._(
      title: title ?? '',
      allFunds:
          allFunds ??
          MultiCurrencyAmount.single(
            Money.fromMajorUnits(
              currency: Currencies.ada,
              majorUnits: BigInt.from(50000000),
            ),
          ),
      totalAsk:
          totalAsk ??
          MultiCurrencyAmount.single(
            Money.fromMajorUnits(
              currency: Currencies.ada,
              majorUnits: BigInt.from(4020000),
            ),
          ),
      timeline: timeline ?? [],
    );
  }

  const NullCurrentCampaignInfoViewModel._({
    required super.title,
    required super.allFunds,
    required super.totalAsk,
    required super.timeline,
  });
}
