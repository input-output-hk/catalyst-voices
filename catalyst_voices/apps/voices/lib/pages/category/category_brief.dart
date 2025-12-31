import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/widgets/change_category_button.dart';
import 'package:catalyst_voices/pages/category/widgets/view_all_category_proposal_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CategoryBrief extends StatelessWidget {
  final String categoryName;
  final String categoryDescription;
  final SignedDocumentRef categoryRef;
  final CategoryBriefType type;
  final bool showViewAllButton;

  const CategoryBrief({
    super.key,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryRef,
    this.type = CategoryBriefType.large,
    this.showViewAllButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Offstage(
          offstage: type.isCompact,
          child: Text(
            context.l10n.category,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        ),
        Text(
          categoryName,
          style: context.textTheme.displaySmall,
        ),
        SizedBox(height: type.isCompact ? 20 : 40),
        Text(
          context.l10n.description,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          categoryDescription,
          style: context.textTheme.bodyLarge,
        ),
        const SizedBox(height: 35),
        Offstage(
          offstage: type.isCompact,
          child: Row(
            children: [
              if (showViewAllButton) ...[
                ViewAllCategoryProposalButton(categoryRef: categoryRef),
                const SizedBox(width: 8),
              ],
              const ChangeCategoryButton(),
            ],
          ),
        ),
      ],
    );
  }
}

enum CategoryBriefType {
  large,
  compact;

  bool get isCompact => this == compact;
  bool get isLarge => this == large;
}
