import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? user;
  final String? notificationsText;
  final String? currentRoleView;
  final bool isNavVisible;
  final bool isLocked;
  final bool isConnecting;
  final bool isGetStarted;
  final bool isFinishAccount;
  final List<Widget> actions;

  const VoicesAppBar({
    super.key,
    this.user,
    this.notificationsText,
    this.currentRoleView,
    this.isNavVisible = false,
    this.isLocked = false,
    this.isConnecting = false,
    this.isGetStarted = false,
    this.isFinishAccount = false,
    this.actions = const [],
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      leading: isNavVisible
          ? IconButton(
              color: Theme.of(context).colors.iconsForeground,
              onPressed: () {},
              icon: const Icon(Icons.menu),
            )
          : null,
      title: Row(
        children: [
          ResponsiveBuilder<String>(
            builder: (context, data) => CatalystSvgPicture.asset(
              data!,
            ),
            xs: Theme.of(context).brandAssets.logoIcon.path,
            other: Theme.of(context).brandAssets.logo.path,
          ),
        ],
      ),
      actions: _actionsWithPadding(
        actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);

  List<Widget> _actionsWithPadding(List<Widget> actions) {
    return actions
        .map(
          (action) => ResponsivePadding(
            xs: const EdgeInsets.symmetric(horizontal: 3),
            sm: const EdgeInsets.symmetric(horizontal: 6),
            md: const EdgeInsets.symmetric(horizontal: 6),
            lg: const EdgeInsets.symmetric(horizontal: 6),
            other: const EdgeInsets.symmetric(horizontal: 6),
            child: action,
          ),
        )
        .toList();
  }
}
