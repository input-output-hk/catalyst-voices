import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/change_category_button.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CategoryDetailView extends StatelessWidget {
  final CampaignCategoryViewModel category;

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
          ),
          const SizedBox(height: 64),
          FundsDetailCard(
            allFunds: category.availableFunds.value,
            totalAsk: category.totalAsk.value,
            askRange: category.range,
            type: FundsDetailCardType.category,
          ),
          const SizedBox(height: 48),
          _ExpandableDescriptionList(
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

  const _CategoryBrief({
    required this.categoryName,
    required this.categoryDescription,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 580),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.category,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          Text(
            categoryName,
            style: context.textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            categoryDescription,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 35),
          const ChangeCategoryButton(),
        ],
      ),
    );
  }
}

class _ExpandableDescriptionList extends StatelessWidget {
  final List<CategoryDescriptionViewModel> descriptions;

  const _ExpandableDescriptionList({
    required this.descriptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: descriptions
          .map<Widget>(
            (e) => VoicesExpansionTile(
              title: _Header(e.title),
              initiallyExpanded: true,
              backgroundColor: Colors.transparent,
              children: [
                _BodyText(e.description),
              ],
            ),
          )
          .separatedBy(const SizedBox(height: 32))
          .toList(),
    );
  }
}

class _Header extends StatelessWidget {
  final String value;

  const _Header(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.titleLarge
          ?.copyWith(color: context.colors.textOnPrimaryLevel1),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String value;

  const _BodyText(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.bodyMedium,
    );
  }
}
