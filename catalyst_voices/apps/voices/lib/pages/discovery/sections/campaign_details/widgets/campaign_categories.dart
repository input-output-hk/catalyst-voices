import 'package:catalyst_voices/widgets/cards/campaign_category_card.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
    return ResponsivePadding(
      xs: const EdgeInsets.symmetric(horizontal: 20),
      sm: const EdgeInsets.symmetric(horizontal: 48),
      md: const EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories
                  .map(
                    (e) => Skeletonizer(
                      enabled: isLoading,
                      child: CampaignCategoryCard(key: ValueKey(e.ref), category: e),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
