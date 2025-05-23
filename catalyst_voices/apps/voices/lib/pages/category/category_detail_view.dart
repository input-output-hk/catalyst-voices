import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/category_brief.dart';
import 'package:catalyst_voices/pages/category/category_description_expadable_list.dart';
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
            categoryRef: category.id,
            image: category.image,
            proposalCount: category.proposalsCount,
          ),
          const SizedBox(height: 64),
          FundsDetailCard(
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
  final int proposalCount;

  const _CategoryBrief({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryRef,
    required this.image,
    required this.proposalCount,
  });

  @override
  Widget build(BuildContext context) {
    final lightColors = [
      const Color(0xFFF6FAFE),
      const Color(0xFFB4DAFD),
      const Color(0xFFF8C1EA),
    ];
    final darkColors = [
      const Color(0xFF1736A3),
      const Color(0xFF4E74B2),
      const Color(0xFF9338C3),
    ];
    final isLight = Theme.of(context).brightness == Brightness.light;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.avatarsPrimary,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: const Alignment(-0.15, 1.8),
          end: const Alignment(0.18, -1.2),
          colors: isLight ? lightColors : darkColors,
          stops: const [0.26, 0.56, 1],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: CategoryBrief(
              categoryName: categoryName,
              categoryDescription: categoryDescription,
              categoryRef: categoryRef,
              showViewAllButton: proposalCount > 0,
            ),
          ),
          Positioned(
            right: -100,
            top: -80,
            child: image.buildPicture(
              height: 380,
              color: context.colors.iconsBackground.withValues(alpha: .4),
            ),
          ),
        ],
      ),
    );
  }
}
