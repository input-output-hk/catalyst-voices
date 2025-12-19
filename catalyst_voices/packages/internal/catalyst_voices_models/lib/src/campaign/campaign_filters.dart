import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignFilters extends Equatable {
  final List<String> categoriesIds;

  const CampaignFilters({
    required this.categoriesIds,
  });

  factory CampaignFilters.from(Campaign campaign) {
    final categoriesIds = campaign.categories.map((e) => e.id.id).toList();
    return CampaignFilters(categoriesIds: categoriesIds);
  }

  @override
  List<Object?> get props => [categoriesIds];

  @override
  String toString() => 'CampaignFilters($categoriesIds)';
}
