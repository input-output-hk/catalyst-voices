import 'package:catalyst_voices/widgets/avatars/space_avatar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/containers/grey_out_container.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _AccessSpaces = ({List<Space> canAccessSpaces, List<Space> availableSpaces});

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
    return BlocSelector<SessionCubit, SessionState, _AccessSpaces>(
      selector: (state) => (
        canAccessSpaces: state.spaces,
        availableSpaces: state.availableSpaces,
      ),
      builder: (context, spaces) {
        return VoicesDrawerChooser<Space>(
          items: spaces.availableSpaces,
          selectedItem: currentSpace,
          onSelected: onChanged,
          itemBuilder: ({
            required context,
            required isSelected,
            required item,
          }) =>
              _itemBuilder(
            context: context,
            item: item,
            isSelected: isSelected,
            canAccess: spaces.canAccessSpaces.contains(item),
          ),
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
    required bool canAccess,
  }) {
    Widget child;
    if (isSelected) {
      child = SpaceAvatar(
        item,
        key: ValueKey('DrawerChooser${item}AvatarKey'),
      );
    } else if (canAccess) {
      child = const VoicesDrawerChooserItemPlaceholder();
    } else {
      child = const GreyOutContainer(
        greyOutOpacity: 0.15,
        child: VoicesDrawerChooserItemPlaceholder(),
      );
    }

    final builder = this.builder;
    if (builder != null) {
      child = builder(context, item, child);
    }

    return child;
  }
}
