import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/menu/voices_raw_popup_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DisplayConsentChoicePicker extends StatelessWidget {
  final List<DropdownMenuViewModel<CollaboratorDisplayConsentStatus>> items;
  final ValueChanged<CollaboratorDisplayConsentStatus> onSelected;
  final GlobalKey<VoicesRawPopupMenuButtonState<dynamic>>? menuKey;
  final BoxConstraints menuConstraints;

  const DisplayConsentChoicePicker({
    super.key,
    required this.items,
    required this.onSelected,
    this.menuKey,
    this.menuConstraints = const BoxConstraints(maxWidth: 205),
  });

  CollaboratorDisplayConsentStatus get _selectedItem =>
      items.firstWhereOrNull((item) => item.isSelected)?.value ??
      CollaboratorDisplayConsentStatus.pending;

  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenuButton<CollaboratorDisplayConsentStatus>(
      key: menuKey,
      buttonBuilder: (context, onTapCallback, {required isMenuOpen}) {
        return _PopupButton(
          selectedItem: _selectedItem,
          onTap: onTapCallback,
        );
      },
      menuBuilder: (context) => _PopupMenu(
        items: items,
        constraints: menuConstraints,
      ),
      onSelected: onSelected,
      routeSettings: const RouteSettings(name: '/display-consent-menu'),
    );
  }
}

class _PopupButton extends StatelessWidget {
  final CollaboratorDisplayConsentStatus selectedItem;
  final VoidCallback onTap;

  const _PopupButton({
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: onTap,
      leading: selectedItem.icons.buildIcon(
        color: selectedItem.foregroundIconColor(context),
      ),
      trailing: VoicesAssets.icons.chevronDown.buildIcon(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        textStyle: context.textTheme.labelMedium,
        foregroundColor: context.colors.textOnPrimaryLevel0,
        backgroundColor: context.colors.elevationsOnSurfaceNeutralLv1White,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
      ),
      child: Text(selectedItem.currentStatusLocalized(context)),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  final List<DropdownMenuViewModel<CollaboratorDisplayConsentStatus>> items;
  final BoxConstraints constraints;

  const _PopupMenu({
    required this.items,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenu(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTileTheme(
        child: ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in items) _PopupMenuItem(item: item),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupMenuItem extends StatelessWidget {
  final DropdownMenuViewModel<CollaboratorDisplayConsentStatus> item;

  const _PopupMenuItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesListTile(
      leading: item.value?.icons.buildIcon(),
      title: Text(item.name),
      tileColor: item.isSelected ? context.colors.onSurfacePrimary08.withValues(alpha: 0.06) : null,
      hoverColor: context.colors.onSurfacePrimary08.withValues(alpha: 0.12),
      onTap: item.isSelected ? null : () => Navigator.of(context).pop(item.value),
    );
  }
}

extension on CollaboratorDisplayConsentStatus {
  Color foregroundIconColor(BuildContext context) {
    return switch (this) {
      CollaboratorDisplayConsentStatus.pending => context.colors.iconsWarning,
      CollaboratorDisplayConsentStatus.allowed => context.colors.iconsSuccess,
      CollaboratorDisplayConsentStatus.denied => context.colors.iconsError,
    };
  }
}
