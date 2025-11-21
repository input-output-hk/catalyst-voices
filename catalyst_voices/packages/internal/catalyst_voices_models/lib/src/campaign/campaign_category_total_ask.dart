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

  CampaignCategoryTotalAsk operator +(CampaignCategoryTotalAsk other) {
    assert(ref == other.ref, 'Refs do not match');

    final finalProposalsCount = this.finalProposalsCount + other.finalProposalsCount;
    final money = [...this.money, ...other.money];

    return copyWith(
      finalProposalsCount: finalProposalsCount,
      money: money,
    );
  }

  CampaignCategoryTotalAsk copyWith({
    DocumentRef? ref,
    int? finalProposalsCount,
    List<Money>? money,
  }) {
    return CampaignCategoryTotalAsk(
      ref: ref ?? this.ref,
      finalProposalsCount: finalProposalsCount ?? this.finalProposalsCount,
      money: money ?? this.money,
    );
  }
}
