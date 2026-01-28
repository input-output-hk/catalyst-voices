import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/category_brief.dart';
import 'package:catalyst_voices/pages/category/widgets/category_description_expandable_list.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/list/category_requirements_list.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
      color: context.colors.onSurfaceNeutralOpaqueLv1,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          const _Background(),
          _Image(image: category.image),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _CategoryBrief(
                  categoryName: category.formattedName,
                  categoryDescription: category.description,
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

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: context.colors.avatarsPrimary,
        gradient: LinearGradient(
          begin: const Alignment(0, 1.4),
          end: const Alignment(0.18, -1.2),
          colors: context.colors.headerGradientSecondary,
          stops: const [0.46, 0.66, 1],
        ),
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

class _Image extends StatelessWidget {
  final SvgGenImage image;

  const _Image({required this.image});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -50,
      top: -50,
      child: image.buildPicture(
        height: 250,
        color: context.colors.iconsBackground.withValues(alpha: .4),
      ),
    );
  }
}
