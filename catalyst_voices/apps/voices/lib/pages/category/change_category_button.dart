import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
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
        List<CategoryChangeViewModel>>(
      selector: (state) {
        final selectedCategory = state.category?.id ?? '';
        return state.categories
            .map(
              (e) => CategoryChangeViewModel(
                categoryId: e.id,
                name: e.formattedName,
                isSelected: e.id == selectedCategory,
              ),
            )
            .toList();
      },
      builder: (context, state) {
        return PopupMenuButton(
          key: _popupMenuButtonKey,
          clipBehavior: Clip.hardEdge,
          onSelected: _changeCategory,
          onCanceled: () => _handleClose,
          onOpened: () => _handleOpen,
          offset: const Offset(0, 40),
          itemBuilder: (context) => state
              .map(
                (e) => CustomPopupMenuItem(
                  value: e.categoryId,
                  color:
                      e.isSelected ? context.colors.onSurfacePrimary08 : null,
                  child: Text(e.name),
                ),
              )
              .toList(),
          constraints: const BoxConstraints(maxWidth: 320),
          color: PopupMenuTheme.of(context).color,
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

  Future<void> _changeCategory(String categoryId) async {
    await context.read<CategoryDetailCubit>().getCategoryDetail(categoryId);
  }
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color? color;

  const CustomPopupMenuItem({
    super.key,
    super.value,
    super.enabled,
    super.child,
    this.color,
  });

  @override
  CustomPopupMenuItemState<T> createState() => CustomPopupMenuItemState<T>();
}

class CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: super.build(context),
    );
  }
}
