part of 'voting_timeline_header.dart';

class _CategoryPicker extends StatelessWidget {
  final int? fundNumber;
  final List<ProposalsCategorySelectorItem> items;

  const _CategoryPicker({
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
      menuTitle: fundNumber != null ? context.l10n.catalystFundNoCategories(fundNumber!) : '-',
    );
  }
}

class _VotingCategoryPicker extends StatelessWidget {
  const _VotingCategoryPicker();

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
        return _CategoryPicker(
          key: const Key('ChangeCategoryBtn'),
          fundNumber: state.fundNumber,
          items: state.items,
        );
      },
    );
  }
}

class _VotingTimelineTitle extends StatelessWidget {
  const _VotingTimelineTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingTimelineTitleViewModel?>(
      selector: (state) => state.votingTimeline?.titleViewModel,
      builder: (context, viewModel) => _VotingTimelineTitleContent(viewModel: viewModel),
    );
  }
}

class _VotingTimelineTitleContent extends StatelessWidget {
  final VotingTimelineTitleViewModel? viewModel;

  const _VotingTimelineTitleContent({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = this.viewModel;
    if (viewModel == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final phaseType = viewModel.phaseType;
    final isExpanded = viewModel.phasesExpanded;
    final showCategoryPicker = viewModel.showCategoryPicker;
    final isVotingDelegated = viewModel.isVotingDelegated;
    final phaseLabel = phaseType.getLabel(context, isVotingDelegated: isVotingDelegated);

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
        if (showCategoryPicker) const _VotingCategoryPicker(),
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
