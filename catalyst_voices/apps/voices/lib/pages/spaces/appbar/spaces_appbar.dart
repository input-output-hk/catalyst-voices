import 'package:catalyst_voices/pages/spaces/appbar/spaces_appbar/discovery_appbar.dart';
import 'package:catalyst_voices/pages/spaces/appbar/spaces_appbar/voting_appbar.dart';
import 'package:catalyst_voices/pages/spaces/appbar/spaces_appbar/workspace_appbar.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Space space;
  final bool isAppUnlock;
  final bool isProposer;

  const SpacesAppbar({
    super.key,
    required this.space,
    required this.isAppUnlock,
    required this.isProposer,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    return switch (space) {
      Space.discovery => DiscoveryAppbar(isAppUnlock: isAppUnlock, isProposer: isProposer),
      Space.workspace => WorkspaceAppbar(isAppUnlock: isAppUnlock),
      Space.voting => VotingAppbar(isAppUnlock: isAppUnlock),
      _ => const SizedBox.shrink(),
    };
  }
}
