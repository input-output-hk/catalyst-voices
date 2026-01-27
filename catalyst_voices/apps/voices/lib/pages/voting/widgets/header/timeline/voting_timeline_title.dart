part of 'voting_timeline_header.dart';

class _CategorySelector extends StatelessWidget {
  final int? fundNumber;
  final List<ProposalsCategorySelectorItem> items;

  const _CategorySelector({
    super.key,
    required this.fundNumber,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CampaignCategoryPicker(
      buttonBuilder: (context, onTapCallback, {required isMenuOpen}) => VoicesOutlinedButton(
        trailing: VoicesAssets.icons.chevronDown.buildIcon(size: 18),
        onTap: onTapCallback,
        child: Text(context.l10n.votingTimelineSelectCategory),
      ),
      items: [
        for (final item in items) item.toDropdownItem(),
      ],
      onSelected: (value) => context.read<VotingCubit>().changeSelectedCategory(value.ref?.id),
      menuTitle: context.l10n.catalystFundNoCategories(fundNumber ?? 14),
    );
  }
}

class _VotingCategoryPickerSelector extends StatelessWidget {
  const _VotingCategoryPickerSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      VotingCubit,
      VotingState,
      ({int? fundNumber, List<ProposalsCategorySelectorItem> items})
    >(
      selector: (state) => (
        fundNumber: state.fundNumber,
        items: state.categorySelectorItems,
      ),
      builder: (context, state) {
        return _CategorySelector(
          key: const Key('ChangeCategoryBtnSelector'),
          fundNumber: state.fundNumber,
          items: state.items,
        );
      },
    );
  }
}

class _VotingTimelineTitle extends StatelessWidget {
  final VotingTimelinePhaseType phaseType;
  final bool isExpanded;
  final bool showCategoryPicker;

  const _VotingTimelineTitle({
    required this.phaseType,
    required this.isExpanded,
    required this.showCategoryPicker,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phaseLabel = phaseType.getLabel(context);

    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Text(
            context.l10n.votingTimeline(phaseLabel),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        VoicesOutlinedButton(
          onTap: context.read<VotingCubit>().togglePhasesExpanded,
          child: Text(
            isExpanded
                ? context.l10n.votingTimelineHideEvents
                : context.l10n.votingTimelineShowEvents,
          ),
        ),
        if (showCategoryPicker) const _VotingCategoryPickerSelector(),
      ],
    );
  }
}

extension on ProposalsCategorySelectorItem {
  DropdownMenuViewModel<ProposalsCategoryFilter> toDropdownItem() {
    return DropdownMenuViewModel(
      value: ProposalsRefCategoryFilter(ref: ref),
      name: name,
      isSelected: isSelected,
    );
  }
}
