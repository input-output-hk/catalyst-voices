import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    as vm;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetailView extends StatelessWidget {
  final vm.CampaignCategoryViewModel category;

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
          const _BackButton(),
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

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      leading: VoicesAssets.icons.arrowLeft.buildIcon(
        color: context.colors.textOnPrimaryLevel1,
      ),
      child: Text(
        context.l10n.backToCampaign,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
      onTap: () {
        const DiscoveryRoute().go(context);
      },
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
          const _ChangeCategoryButton(),
        ],
      ),
    );
  }
}

typedef _StateData = ({
  List<vm.CampaignCategoryViewModel> categories,
  vm.CampaignCategoryViewModel? category,
});

class _ChangeCategoryButton extends StatefulWidget {
  const _ChangeCategoryButton();

  @override
  State<_ChangeCategoryButton> createState() => _ChangeCategoryButtonState();
}

class _ChangeCategoryButtonState extends State<_ChangeCategoryButton> {
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState<dynamic>>();
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState, _StateData>(
      selector: (state) {
        if (state is CategoryDetailData) {
          return (categories: state.categories, category: state.category);
        }
        return (categories: state.categories, category: null);
      },
      builder: (context, state) {
        return PopupMenuButton(
          key: _popupMenuButtonKey,
          clipBehavior: Clip.hardEdge,
          onSelected: _changeCategory,
          onCanceled: () => _handleClose,
          onOpened: () => _handleOpen,
          offset: const Offset(0, 40),
          itemBuilder: (context) => state.categories
              .map(
                (e) => CustomPopupMenuItem(
                  value: e.id,
                  color: e.id == state.category?.id
                      ? context.colors.onSurfacePrimary08
                      : null,
                  child: Text(e.formattedName),
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
    await context.read<CategoryDetailCubit>().changeCategory(categoryId);
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

class _ExpandableDescriptionList extends StatelessWidget {
  final List<vm.CategoryDescriptionViewModel> descriptions;

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
