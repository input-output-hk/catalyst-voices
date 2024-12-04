import 'package:catalyst_voices/common/utils/access_control_util.dart';
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
    return BlocSelector<SessionCubit, SessionState, Account?>(
      selector: (state) {
        if (state is ActiveAccountSessionState) {
          return state.account;
        }
        return null;
      },
      builder: (context, state) {
        return VoicesDrawerChooser<Space>(
          items: AccessControlUtil.spacesAccess(state),
          selectedItem: currentSpace,
          onSelected: onChanged,
          itemBuilder: _itemBuilder,
          leading: VoicesIconButton(
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
