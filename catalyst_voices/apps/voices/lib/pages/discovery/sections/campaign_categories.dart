import 'package:catalyst_voices/widgets/cards/campaign_category_card.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CampaignCategories extends StatelessWidget {
  final List<CampaignCategoryDetailsViewModel> categories;
  final bool isLoading;

  const CampaignCategories(
    this.categories, {
    super.key,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 120,
        right: 120,
        bottom: 24,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories
            .map(
              (e) => IntrinsicHeight(
                child: Skeletonizer(
                  enabled: isLoading,
                  child: CampaignCategoryCard(category: e),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
