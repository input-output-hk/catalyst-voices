import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/category_brief.dart';
import 'package:catalyst_voices/pages/category/category_description_expandable_list.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CategoryDetailView extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;

  const CategoryDetailView({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 112),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationBack(
            label: context.l10n.backToCampaign,
          ),
          const SizedBox(height: 32),
          _CategoryBrief(
            categoryName: category.formattedName,
            categoryDescription: category.description,
            categoryRef: category.ref,
            image: category.image,
            finalProposalsCount: category.finalProposalsCount,
          ),
          const SizedBox(height: 64),
          FundsDetailCard(
            key: const Key('CategoryDetailCard'),
            allFunds: category.availableFunds,
            totalAsk: category.totalAsk,
            askRange: category.range,
            type: FundsDetailCardType.category,
          ),
          const SizedBox(height: 48),
          CategoryDescriptionExpandableList(
            descriptions: category.descriptions,
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
  final SvgGenImage image;
  final int finalProposalsCount;

  const _CategoryBrief({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryRef,
    required this.image,
    required this.finalProposalsCount,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.avatarsPrimary,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: const Alignment(-0.15, 1.8),
          end: const Alignment(0.18, -1.2),
          colors: context.colors.headerGradient,
          stops: const [0.26, 0.56, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -100,
            top: -80,
            child: image.buildPicture(
              height: 380,
              color: context.colors.iconsBackground.withValues(alpha: .4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: CategoryBrief(
              categoryName: categoryName,
              categoryDescription: categoryDescription,
              categoryRef: categoryRef,
              showViewAllButton: finalProposalsCount > 0,
            ),
          ),
        ],
      ),
    );
  }
}
