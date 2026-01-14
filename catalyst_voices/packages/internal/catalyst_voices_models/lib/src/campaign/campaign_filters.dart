import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class CampaignFilters extends Equatable {
  final List<String> categoriesIds;

  const CampaignFilters({
    required this.categoriesIds,
  });

  factory CampaignFilters.active() {
    final categoriesIds = Campaign.all
        .where((campaign) => campaign.id == activeCampaignRef)
        .map((campaign) => campaign.categories.map((category) => category.id.id))
        .flattened
        .toSet()
        .toList();

    return CampaignFilters(categoriesIds: categoriesIds);
  }

  factory CampaignFilters.from(Campaign campaign) {
    final categoriesIds = campaign.categories.map((e) => e.id.id).toSet().toList();
    return CampaignFilters(categoriesIds: categoriesIds);
  }

  @override
  List<Object?> get props => [categoriesIds];

  @override
  String toString() => 'CampaignFilters($categoriesIds)';
}
