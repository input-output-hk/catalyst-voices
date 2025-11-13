import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignCategoryTotalAsk extends Equatable {
  final DocumentRef ref;
  final int finalProposalsCount;
  final List<Money> money;

  const CampaignCategoryTotalAsk({
    required this.ref,
    required this.finalProposalsCount,
    required this.money,
  });

  const CampaignCategoryTotalAsk.zero(this.ref) : finalProposalsCount = 0, money = const [];

  @override
  List<Object?> get props => [
    ref,
    finalProposalsCount,
    money,
  ];

  MultiCurrencyAmount get totalAsk => MultiCurrencyAmount.list(money);
}
