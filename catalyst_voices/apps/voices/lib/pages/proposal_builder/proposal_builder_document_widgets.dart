part of 'proposal_builder_segments.dart';

class _CategoryDetails extends StatelessWidget {
  final DocumentProperty property;

  const _CategoryDetails({required this.property});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        CampaignCategoryDetailsViewModel?>(
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
              category.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              category.subname,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            _Stats(category: category),
            const SizedBox(height: 20),
            Text(
              context.l10n.shortSummary,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              style: Theme.of(context).textTheme.bodyLarge,
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
            value: category.availableFunds,
          ),
        ),
        Expanded(
          child: _StatsItem(
            label: context.l10n.minBudgetRequest,
            value: category.range.min,
          ),
        ),
        Expanded(
          child: _StatsItem(
            label: context.l10n.maxBudgetRequest,
            value: category.range.max,
          ),
        ),
      ],
    );
  }
}

class _StatsItem extends StatelessWidget {
  final String label;
  final Coin value;

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
          CryptocurrencyFormatter.formatAmount(value),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
