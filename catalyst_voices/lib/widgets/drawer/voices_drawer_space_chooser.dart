import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/avatars/space_avatar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_keyboard_key_button.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/tooltips/voices_plain_tooltip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesDrawerSpaceChooser extends StatelessWidget {
  final Space currentSpace;
  final ValueChanged<Space> onChanged;
  final VoidCallback? onOverallTap;

  const VoicesDrawerSpaceChooser({
    super.key,
    required this.currentSpace,
    required this.onChanged,
    this.onOverallTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawerChooser<Space>(
      items: Space.values,
      selectedItem: currentSpace,
      onSelected: onChanged,
      itemBuilder: _itemBuilder,
      leading: VoicesIconButton(
        onTap: onOverallTap,
        child: VoicesAssets.icons.allSpacesMenu.buildIcon(size: 20),
      ),
    );
  }

  Widget _itemBuilder({
    required BuildContext context,
    required Space item,
    required bool isSelected,
  }) {
    final child = isSelected
        ? SpaceAvatar(
            item,
            key: ValueKey('DrawerChooser${item}AvatarKey'),
          )
        : const VoicesDrawerChooserItemPlaceholder();

    return VoicesPlainTooltip(
      message: item.localizedName(context.l10n),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VoicesKeyboardKeyButton(
              child: VoicesAssets.icons.chevronUp.buildIcon()),
          const SizedBox(width: 4),
          const VoicesKeyboardKeyButton(child: Text('1')),
        ],
      ),
      child: child,
    );
  }
}
