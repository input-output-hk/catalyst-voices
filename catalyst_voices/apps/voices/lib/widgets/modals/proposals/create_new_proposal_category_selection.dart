import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/category_compact_detail_view.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CreateNewProposalCategorySelection extends StatelessWidget {
  final List<CampaignCategoryDetailsViewModel> categories;
  final SignedDocumentRef? selectedCategory;
  final ValueChanged<SignedDocumentRef?> onCategorySelected;

  const CreateNewProposalCategorySelection({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  CampaignCategoryDetailsViewModel? get _selectedCategory {
    return categories.firstWhereOrNull((element) => element.id == selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: categories
                .map(
                  (e) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.colors.outlineBorder,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Text(e.name),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _selectedCategory != null
              ? CategoryCompactDetailView(category: _selectedCategory!)
              : const _NoneCategorySelected(),
        ),
      ],
    );
  }
}

class _NoneCategorySelected extends StatelessWidget {
  const _NoneCategorySelected();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          Text(
            context.l10n.selectCategoryToSeeDetailsTitle,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          Text(
            context.l10n.selectCategoryToSeeDetailsDescription,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
