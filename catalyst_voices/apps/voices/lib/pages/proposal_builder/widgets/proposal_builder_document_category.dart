part of '../proposal_builder_segments.dart';

class _CategoryDetails extends StatelessWidget {
  final DocumentProperty property;

  const _CategoryDetails({required this.property});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProposalBuilderBloc,
      ProposalBuilderState,
      CampaignCategoryDetailsViewModel?
    >(
      selector: (state) => state.category,
      builder: (context, category) {
        if (category == null) {
          return const Offstage();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.formattedName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            _Stats(category: category),
            const SizedBox(height: 28),
            CategoryRequirementsList(
              dos: category.dos,
              donts: category.donts,
            ),
          ],
        );
      },
    );
  }
}

class _Stats extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;

  const _Stats({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatsItem(
            label: context.l10n.fundsAvailable,
            value: MoneyFormatter.formatMultiCurrencyAmount(
              category.availableFunds,
              formatter: MoneyFormatter.formatCompactRounded,
              separator: ', ',
            ),
          ),
        ),
        Expanded(
          child: _StatsItem(
            label: context.l10n.minBudgetRequest,
            value: MoneyFormatter.formatCompactRounded(category.range.min),
          ),
        ),
        Expanded(
          child: _StatsItem(
            label: context.l10n.maxBudgetRequest,
            value: MoneyFormatter.formatCompactRounded(category.range.max),
          ),
        ),
      ],
    );
  }
}

class _StatsItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatsItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: context.colors.textOnPrimaryLevel1),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: context.colors.textOnPrimaryLevel1),
        ),
      ],
    );
  }
}
