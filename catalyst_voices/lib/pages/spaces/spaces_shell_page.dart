import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesShellPage extends StatelessWidget {
  final Space space;
  final Widget child;

  const SpacesShellPage({
    super.key,
    required this.space,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(),
      drawer: _SpacesDrawer(space: space),
      body: child,
    );
  }
}

class _SpacesDrawer extends StatelessWidget {
  final Space space;

  const _SpacesDrawer({
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      children: [],
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: space,
        onChanged: (space) {
          Scaffold.of(context).closeDrawer();
          _goTo(context, space: space);
        },
      ),
    );
  }

  void _goTo(
    BuildContext context, {
    required Space space,
  }) {
    switch (space) {
      case Space.treasury:
        TreasuryRoute().go(context);
      case Space.discovery:
        DiscoveryRoute().go(context);
      case Space.workspace:
        WorkspaceRoute().go(context);
      case Space.voting:
        VotingRoute().go(context);
      case Space.fundedProjects:
        FundedProjectsRoute().go(context);
    }
  }
}
