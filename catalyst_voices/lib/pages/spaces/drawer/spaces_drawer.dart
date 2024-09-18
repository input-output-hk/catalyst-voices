import 'dart:async';

import 'package:catalyst_voices/pages/spaces/drawer/discovery_menu.dart';
import 'package:catalyst_voices/pages/spaces/drawer/guest_menu.dart';
import 'package:catalyst_voices/pages/spaces/drawer/individual_private_campaigns.dart';
import 'package:catalyst_voices/pages/spaces/drawer/my_private_proposals.dart';
import 'package:catalyst_voices/pages/spaces/drawer/voting_rounds.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesDrawer extends StatefulWidget {
  final Space space;
  final bool isUnlocked;

  const SpacesDrawer({
    super.key,
    required this.space,
    this.isUnlocked = false,
  });

  @override
  State<SpacesDrawer> createState() => _SpacesDrawerState();
}

class _SpacesDrawerState extends State<SpacesDrawer> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    final initialPage = Space.values.indexOf(widget.space);
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void didUpdateWidget(covariant SpacesDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.space != oldWidget.space) {
      final page = Space.values.indexOf(widget.space);
      unawaited(
        _pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: widget.space,
        onChanged: (space) {
          _goTo(context, space: space);
        },
        onOverallTap: () {
          Scaffold.of(context).closeDrawer();
          unawaited(const OverallSpacesRoute().push<void>(context));
        },
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const BrandHeader(),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: Space.values.length,
              itemBuilder: (context, index) {
                final space = Space.values[index];

                return Padding(
                  key: ValueKey('Drawer${space}MenuKey'),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _menuBuilder(
                    context,
                    space: space,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _menuBuilder(
    BuildContext context, {
    required Space space,
  }) {
    return switch (space) {
      _ when !widget.isUnlocked => GuestMenu(space: space),
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
