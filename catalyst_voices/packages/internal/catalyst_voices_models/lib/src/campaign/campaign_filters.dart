import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A set of filters to be applied when querying for campaign related data.
final class CampaignFilters extends Equatable {
  /// Filters by category IDs.
  final Set<String> categoriesIds;

  const CampaignFilters({
    required this.categoriesIds,
  });

  /// Currently hardcoded active campaign helper constructor.
  factory CampaignFilters.active() {
    final categoriesIds = Campaign.all
        .where((campaign) => campaign.id == activeCampaignRef)
        .map((campaign) => campaign.categories.map((category) => category.id.id))
        .flattened
        .toSet();

    return CampaignFilters(categoriesIds: categoriesIds);
  }

  factory CampaignFilters.from(Campaign campaign) {
    final categoriesIds = campaign.categories.map((e) => e.id.id).toSet();

    return CampaignFilters(categoriesIds: categoriesIds);
  }

  @override
  List<Object?> get props => [categoriesIds];

  @override
  String toString() => 'categoriesIds: $categoriesIds';
}
