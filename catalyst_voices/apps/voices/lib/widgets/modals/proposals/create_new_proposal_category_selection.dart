import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/category_compact_detail_view.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateNewProposalCategorySelection extends StatefulWidget {
  final NewProposalStateCategories categories;
  final ValueChanged<SignedDocumentRef?> onCategorySelected;

  const CreateNewProposalCategorySelection({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CreateNewProposalCategorySelection> createState() =>
      _CreateNewProposalCategorySelectionState();
}

class _CategoryCard extends StatelessWidget {
  final SignedDocumentRef ref;
  final String name;
  final String description;
  final bool isSelected;
  final ValueChanged<SignedDocumentRef?> onCategorySelected;

  const _CategoryCard({
    required this.ref,
    required this.name,
    required this.description,
    required this.isSelected,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => onCategorySelected(ref),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? context.colorScheme.primary : context.colors.outlineBorder,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colors.textOnPrimaryLevel0,
                ),
              ),
              Text(
                description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textOnPrimaryLevel1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateNewProposalCategorySelectionState extends State<CreateNewProposalCategorySelection> {
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories.categories ?? [];
    final selected = widget.categories.selected;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 68),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => _CategoryCard(
                  name: categories[index].formattedName,
                  description: categories[index].shortDescription,
                  ref: categories[index].id,
                  isSelected: categories[index].id == selected?.id,
                  onCategorySelected: widget.onCategorySelected,
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemCount: categories.length,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: selected != null
                  ? VoicesScrollbar(
                      controller: _scrollController,
                      alwaysVisible: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: CategoryCompactDetailView(category: selected),
                      ),
                    )
                  : const _NoneCategorySelected(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
