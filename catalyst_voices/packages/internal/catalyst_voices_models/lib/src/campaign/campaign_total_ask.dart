import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class CampaignTotalAsk extends Equatable {
  final Map<DocumentRef, CampaignCategoryTotalAsk> categoriesAsks;

  const CampaignTotalAsk({
    required this.categoriesAsks,
  });

  @override
  List<Object?> get props => [categoriesAsks];

  MultiCurrencyAmount get totalAsk {
    final categoriesMoney = categoriesAsks.values.map((e) => e.money).flattened.toList();
    return MultiCurrencyAmount.list(categoriesMoney);
  }

  CampaignCategoryTotalAsk? category(SignedDocumentRef ref) {
    return categoriesAsks.entries.firstWhereOrNull((entry) => entry.key.id == ref.id)?.value;
  }

  CampaignCategoryTotalAsk categoryOrZero(SignedDocumentRef ref) {
    return category(ref) ?? CampaignCategoryTotalAsk.zero(ref);
  }
}
