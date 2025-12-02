import 'package:catalyst_voices/widgets/dropdown/campaign_category_picker.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingCategoryPickerSelector extends StatelessWidget {
  const VotingCategoryPickerSelector({super.key});

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
      items: [
        for (final item in items) item.toDropdownItem(),
      ],
      onSelected: (value) {
        context.read<VotingCubit>().changeSelectedCategory(value.ref?.id);
      },
      menuTitle: context.l10n.catalystFundNo(fundNumber ?? 14),
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
