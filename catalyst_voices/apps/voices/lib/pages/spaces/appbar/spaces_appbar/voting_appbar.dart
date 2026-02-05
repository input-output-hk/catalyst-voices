import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/voting_category_leading_button.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAppUnlock;

  const VotingAppbar({
    super.key,
    required this.isAppUnlock,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, bool>(
      selector: (state) => state.hasSelectedCategory,
      builder: (context, hasCategory) {
        return _VotingAppbar(
          isAppUnlock: isAppUnlock,
          hasCategory: hasCategory,
        );
      },
    );
  }
}

class _VotingAppbar extends StatelessWidget {
  final bool isAppUnlock;
  final bool hasCategory;

  const _VotingAppbar({
    required this.isAppUnlock,
    required this.hasCategory,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAppBar(
      leading: _getLeadingWidget(),
      automaticallyImplyLeading: false,
      actions: const [
        SessionCtaAction(),
        AccountSettingsAction(),
      ],
    );
  }

  Widget? _getLeadingWidget() {
    if (!isAppUnlock) {
      return null;
    } else if (hasCategory) {
      return const VotingCategoryLeadingButton();
    } else {
      return const DrawerToggleButton();
    }
  }
}
