import 'package:catalyst_voices/widgets/avatars/space_avatar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoicesDrawerSpaceChooser extends StatelessWidget {
  final Space currentSpace;
  final ValueChanged<Space> onChanged;
  final VoidCallback? onOverallTap;
  final ValueWidgetBuilder<Space>? builder;

  const VoicesDrawerSpaceChooser({
    super.key,
    required this.currentSpace,
    required this.onChanged,
    this.onOverallTap,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, List<Space>>(
      selector: (state) => state.spaces,
      builder: (context, spaces) {
        return VoicesDrawerChooser<Space>(
          items: spaces,
          selectedItem: currentSpace,
          onSelected: onChanged,
          itemBuilder: _itemBuilder,
          leading: VoicesIconButton(
            key: const ValueKey('DrawerChooserAllSpacesButton'),
            onTap: onOverallTap,
            child: VoicesAssets.icons.allSpacesMenu.buildIcon(size: 20),
          ),
        );
      },
    );
  }

  Widget _itemBuilder({
    required BuildContext context,
    required Space item,
    required bool isSelected,
  }) {
    Widget child = isSelected
        ? SpaceAvatar(
            item,
            key: ValueKey('DrawerChooser${item}AvatarKey'),
          )
        : const VoicesDrawerChooserItemPlaceholder();

    final builder = this.builder;
    if (builder != null) {
      child = builder(context, item, child);
    }

    return child;
  }
}
