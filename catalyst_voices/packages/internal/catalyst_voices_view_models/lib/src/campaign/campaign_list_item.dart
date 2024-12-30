import 'package:catalyst_voices_view_models/src/campaign/campaign_category_section.dart';
import 'package:equatable/equatable.dart';

sealed class CampaignListItem extends Equatable {}

final class CampaignDetailsListItem extends CampaignListItem {
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final int categoriesCount;

  CampaignDetailsListItem({
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.categoriesCount,
  });

  @override
  List<Object?> get props => [
        description,
        startDate,
        endDate,
        proposalsCount,
        categoriesCount,
      ];
}

final class CampaignCategoriesListItem extends CampaignListItem {
  final List<CampaignCategorySection> sections;

  CampaignCategoriesListItem({
    required this.sections,
  });

  @override
  List<Object?> get props => [
        sections,
      ];
}
