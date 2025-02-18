import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/dropdown/category_dropdown.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    hide PopupMenuItem;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeCategoryButton extends StatefulWidget {
  const ChangeCategoryButton({super.key});

  @override
  State<ChangeCategoryButton> createState() => _ChangeCategoryButtonState();
}

class _ChangeCategoryButtonState extends State<ChangeCategoryButton> {
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState<dynamic>>();
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState,
        List<DropdownMenuViewModel>>(
      selector: (state) {
        final selectedCategory = state.category?.id ?? '';
        return state.categories
            .map(
              (e) => DropdownMenuViewModel(
                value: e.id,
                name: e.formattedName,
                isSelected: e.id == selectedCategory,
              ),
            )
            .toList();
      },
      builder: (context, state) {
        return CategoryDropdown(
          popupMenuButtonKey: _popupMenuButtonKey,
          clipBehavior: Clip.hardEdge,
          onSelected: _changeCategory,
          onCanceled: () => _handleClose,
          onOpened: () => _handleOpen,
          offset: const Offset(0, 40),
          items: state,
          constraints: const BoxConstraints(maxWidth: 320),
          highlightColor: context.colors.onSurfacePrimary08,
          child: VoicesOutlinedButton(
            onTap: () {
              _popupMenuButtonKey.currentState?.showButtonMenu();
            },
            trailing: VoicesAssets.icons.chevronDown.buildIcon(),
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  isOpen ? context.colors.onSurfacePrimary08 : null,
            ),
            child: Text(
              context.l10n.exploreCategories,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeCategory(String? categoryId) async {
    if (categoryId == null) {
      return;
    }
    await context.read<CategoryDetailCubit>().getCategoryDetail(categoryId);
  }

  void _handleClose() {
    setState(() {
      isOpen = false;
    });
  }

  void _handleOpen() {
    setState(() {
      isOpen = true;
    });
  }
}
