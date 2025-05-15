import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/category_dropdown.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, List<ProposalsCategorySelectorItem>>(
      selector: (state) => state.categorySelectorItems,
      builder: (context, state) {
        return _CategorySelector(
          key: const Key('ChangeCategoryBtnSelector'),
          items: state,
        );
      },
    );
  }
}

class _CategorySelector extends StatefulWidget {
  final List<ProposalsCategorySelectorItem> items;

  const _CategorySelector({
    super.key,
    required this.items,
  });

  @override
  State<_CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<_CategorySelector> {
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState<dynamic>>();

  @override
  Widget build(BuildContext context) {
    return CategoryDropdown(
      items: [
        DropdownMenuViewModel(
          value: const ProposalsAnyCategoryFilter(),
          name: context.l10n.showAll,
          isSelected: widget.items.none((e) => e.isSelected),
        ),
        ...widget.items.map((item) => item.toDropdownItem()),
      ],
      highlightColor: context.colors.onSurfacePrimary08,
      onSelected: (value) {
        context.read<ProposalsCubit>().changeSelectedCategory(value.ref);
      },
      popupMenuButtonKey: _popupMenuButtonKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1White,
          border: Border.all(color: context.colors.outlineBorderVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              key: const Key('CategorySelectorLabel'),
              context.l10n.category,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textDisabled,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              key: const Key('CategorySelectorValue'),
              widget.items.firstWhereOrNull((e) => e.isSelected)?.name ??
                  context.l10n.showAll, //widget.selectedName,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(width: 8),
            VoicesAssets.icons.chevronDown.buildIcon(),
          ],
        ),
      ),
    );
  }
}

extension on ProposalsCategorySelectorItem {
  DropdownMenuViewModel<ProposalsCategoryFilter> toDropdownItem() {
    return DropdownMenuViewModel(
      value: ProposalsRefCategoryFilter(ref: ref),
      name: name.trim().isNotEmpty ? name : '-TBD-',
      isSelected: isSelected,
    );
  }
}
