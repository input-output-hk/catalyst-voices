import 'dart:async';

import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/pages/spaces/drawer/discovery_menu.dart';
import 'package:catalyst_voices/pages/spaces/drawer/guest_menu.dart';
import 'package:catalyst_voices/pages/spaces/drawer/individual_private_campaigns.dart';
import 'package:catalyst_voices/pages/spaces/drawer/my_private_proposals.dart';
import 'package:catalyst_voices/pages/spaces/drawer/voting_rounds.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesDrawer extends StatelessWidget {
  final Space space;
  final Map<Space, ShortcutActivator> spacesShortcutsActivators;
  final bool isUnlocked;

  const SpacesDrawer({
    super.key,
    required this.space,
    this.spacesShortcutsActivators = const {},
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: space,
        onChanged: (space) => space.go(context),
        onOverallTap: () {
          Scaffold.of(context).closeDrawer();
          unawaited(const OverallSpacesRoute().push<void>(context));
        },
        builder: (context, value, child) {
          final shortcutActivator = spacesShortcutsActivators[value];

          return VoicesPlainTooltip(
            message: value.localizedName(context.l10n),
            trailing: shortcutActivator != null
                ? ShortcutActivatorView(activator: shortcutActivator)
                : null,
            child: child!,
          );
        },
      ),
      children: [
        _menuBuilder(),
      ],
    );
  }

  Widget _menuBuilder() {
    return switch (space) {
      _ when !isUnlocked => GuestMenu(space: space),
      Space.treasury => const IndividualPrivateCampaigns(),
      Space.workspace => const MyPrivateProposals(),
      Space.voting => const VotingRounds(),
      Space.discovery => const DiscoveryDrawerMenu(),
      Space.fundedProjects => const SizedBox.shrink(),
    };
  }

  void _goTo(
    BuildContext context, {
    required Space space,
  }) {
    switch (space) {
      case Space.treasury:
        const TreasuryRoute().go(context);
      case Space.discovery:
        const DiscoveryRoute().go(context);
      case Space.workspace:
        const WorkspaceRoute().go(context);
      case Space.voting:
        const VotingRoute().go(context);
      case Space.fundedProjects:
        const FundedProjectsRoute().go(context);
    }
  }
}
