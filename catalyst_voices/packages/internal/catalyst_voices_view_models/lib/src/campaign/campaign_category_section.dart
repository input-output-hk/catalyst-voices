import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/menu/menu_item.dart';
import 'package:equatable/equatable.dart';

final class CampaignCategorySection extends Equatable implements MenuItem {
  @override
  final String id;
  final CampaignCategory category;
  final String title;
  final String body;
  @override
  final bool isEnabled;

  const CampaignCategorySection({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    this.isEnabled = true,
  });

  CampaignCategorySection.fromCategory(CampaignSection section)
      : this(
          id: section.id,
          category: section.category,
          title: section.title,
          body: section.body,
        );

  @override
  String get label => category.name;

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        body,
        isEnabled,
      ];
}
