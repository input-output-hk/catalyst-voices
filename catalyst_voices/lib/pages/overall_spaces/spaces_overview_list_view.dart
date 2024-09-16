import 'package:catalyst_voices/pages/overall_spaces/space/discovery_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/funded_projects_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/treasury_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/voting_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/workspace_overview.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesListView extends StatefulWidget {
  const SpacesListView({
    super.key,
  });

  @override
  State<SpacesListView> createState() => _SpacesListViewState();
}

class _SpacesListViewState extends State<SpacesListView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesScrollbar(
      controller: _scrollController,
      alwaysVisible: true,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 16, bottom: 24),
        itemBuilder: (context, index) {
          final space = Space.values[index];
          return switch (space) {
            Space.treasury => TreasuryOverview(key: ObjectKey(space)),
            Space.discovery => DiscoveryOverview(key: ObjectKey(space)),
            Space.workspace => WorkspaceOverview(key: ObjectKey(space)),
            Space.voting => VotingOverview(key: ObjectKey(space)),
            Space.fundedProjects =>
              FundedProjectsOverview(key: ObjectKey(space)),
          };
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemCount: Space.values.length,
      ),
    );
  }
}
