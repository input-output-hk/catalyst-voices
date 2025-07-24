import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/dropdown/campaign_category_picker.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart' hide PopupMenuItem;
import 'package:flutter/material.dart';

class ChangeCategoryButton extends StatefulWidget {
  const ChangeCategoryButton({super.key});

  @override
  State<ChangeCategoryButton> createState() => _ChangeCategoryButtonState();
}

class _ChangeCategoryButtonState extends State<ChangeCategoryButton> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState,
        List<DropdownMenuViewModel<ProposalsCategoryFilter>>>(
      selector: (state) {
        final selectedCategory = state.category?.id ?? '';
        return state.categories
            .map(
              (e) => DropdownMenuViewModel(
                value: ProposalsRefCategoryFilter(ref: e.id),
                name: e.formattedName,
                isSelected: e.id == selectedCategory,
              ),
            )
            .toList();
      },
      builder: (context, state) {
        return CampaignCategoryPicker(
          onSelected: _changeCategory,
          items: state,
          buttonBuilder: (
            context,
            onTapCallback, {
            required isMenuOpen,
          }) {
            return VoicesOutlinedButton(
              onTap: onTapCallback,
              trailing: VoicesAssets.icons.chevronDown.buildIcon(),
              style: OutlinedButton.styleFrom(
                backgroundColor: isMenuOpen ? context.colors.onSurfacePrimary08 : null,
              ),
              child: Text(
                context.l10n.exploreCategories,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _changeCategory(ProposalsCategoryFilter value) async {
    final ref = value.ref;
    if (ref == null) {
      return;
    }
    await context.read<CategoryDetailCubit>().getCategoryDetail(ref);
  }
}
