import 'package:catalyst_voices/widgets/avatars/space_avatar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
        child: const Icon(
          CatalystVoicesIcons.all_spaces_menu,
          size: 20,
        ),
        onTap: onOverallTap,
      ),
    );
  }

  Widget _itemBuilder({
    required BuildContext context,
    required Space item,
    required bool isSelected,
  }) {
    if (isSelected) {
      return SpaceAvatar(
        item,
        key: ValueKey('DrawerChooser${item}AvatarKey'),
      );
    } else {
      return const VoicesDrawerChooserItemPlaceholder();
    }
  }
}
