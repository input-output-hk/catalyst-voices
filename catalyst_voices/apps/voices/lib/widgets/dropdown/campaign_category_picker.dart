import 'package:catalyst_voices/widgets/menu/voices_raw_popup_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart' hide PopupMenuItem;
import 'package:flutter/material.dart';

class CampaignCategoryPicker extends StatelessWidget {
  final List<DropdownMenuViewModel<ProposalsCategoryFilter>> items;
  final ValueChanged<ProposalsCategoryFilter> onSelected;
  final GlobalKey<VoicesRawPopupMenuButtonState<dynamic>>? menuKey;
  final String? menuTitle;
  final Offset menuOffset;
  final BoxConstraints menuConstraints;
  final bool menuWithIcons;
  final VoicesRawPopupBuilder? buttonBuilder;

  const CampaignCategoryPicker({
    super.key,
    required this.items,
    required this.onSelected,
    this.menuKey,
    this.menuTitle,
    this.menuOffset = const Offset(0, 8),
    this.menuConstraints = const BoxConstraints(maxWidth: 400),
    this.menuWithIcons = true,
    this.buttonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenuButton<ProposalsCategoryFilter>(
      key: menuKey,
      buttonBuilder: buttonBuilder ??
          (
            context,
            onTapCallback, {
            required isMenuOpen,
          }) {
            return VoicesFilledButton(
              onTap: onTapCallback,
              trailing: VoicesAssets.icons.chevronDown.buildIcon(),
              child: Text(context.l10n.categories),
            );
          },
      menuBuilder: (context) => _PopupMenu(
        title: menuTitle,
        items: items,
        constraints: menuConstraints,
        withIcons: menuWithIcons,
      ),
      menuOffset: menuOffset,
      onSelected: onSelected,
      routeSettings: const RouteSettings(name: '/campaign-category-picker'),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  final String? title;
  final List<DropdownMenuViewModel<ProposalsCategoryFilter>> items;
  final BoxConstraints constraints;
  final bool withIcons;

  const _PopupMenu({
    required this.title,
    required this.items,
    required this.constraints,
    required this.withIcons,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final listTileTheme = ListTileTheme.of(context).copyWith(
      shape: const RoundedRectangleBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );

    return VoicesRawPopupMenu(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTileTheme(
        data: listTileTheme,
        child: ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) _PopupMenuTitle(title: title),
              for (final item in items)
                _PopupMenuItem(
                  item: item,
                  withIcons: withIcons,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupMenuItem extends StatelessWidget {
  final DropdownMenuViewModel<ProposalsCategoryFilter> item;
  final bool withIcons;

  const _PopupMenuItem({
    required this.item,
    required this.withIcons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colors.textOnPrimaryLevel1;

    return VoicesListTile(
      title: Text(item.name),
      leading: withIcons ? VoicesAssets.icons.viewGrid.buildIcon(color: iconColor) : null,
      trailing: withIcons ? VoicesAssets.icons.chevronRight.buildIcon(color: iconColor) : null,
      tileColor: item.isSelected ? theme.colors.onSurfacePrimary08 : null,
      onTap: () => Navigator.of(context).pop(item.value),
    );
  }
}

class _PopupMenuTitle extends StatelessWidget {
  final String title;

  const _PopupMenuTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}
