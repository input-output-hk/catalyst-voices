import 'package:catalyst_voices/pages/category/category_brief.dart';
import 'package:catalyst_voices/pages/category/category_description_expadable_list.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/containers/linear_gradient_header.dart';
import 'package:catalyst_voices/widgets/list/category_requirments_list.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CategoryCompactDetailView extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;

  const CategoryCompactDetailView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          const LinearGradientHeader(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _CategoryBrief(
                  categoryName: category.formattedName,
                  categoryDescription: category.shortDescription,
                  categoryRef: category.id,
                ),
                FundsDetailCard(
                  allFunds: category.availableFunds,
                  totalAsk: category.totalAsk,
                  askRange: category.range,
                  type: FundsDetailCardType.categoryCompact,
                ),
                const SizedBox(height: 6),
                CategoryRequirementsList(
                  dos: category.dos,
                  donts: category.donts,
                ),
                const SizedBox(height: 20),
                CategoryDescriptionExpandableList(
                  descriptions: category.descriptions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBrief extends StatelessWidget {
  final String categoryName;
  final String categoryDescription;
  final SignedDocumentRef categoryRef;

  const _CategoryBrief({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryRef,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryBrief(
      categoryName: categoryName,
      categoryDescription: categoryDescription,
      categoryRef: categoryRef,
      showViewAllButton: false,
      type: CategoryBriefType.compact,
    );
  }
}
