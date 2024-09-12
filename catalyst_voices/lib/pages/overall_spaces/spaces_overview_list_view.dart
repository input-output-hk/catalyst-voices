import 'package:catalyst_voices/pages/overall_spaces/space/discovery_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/funded_projects_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/treasury_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/voting_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/workspace_overview.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesListView extends StatelessWidget {
  const SpacesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(right: 16),
      itemBuilder: (context, index) {
        final space = Space.values[index];
        return switch (space) {
          Space.treasury => TreasuryOverview(key: ObjectKey(space)),
          Space.discovery => DiscoveryOverview(key: ObjectKey(space)),
          Space.workspace => WorkspaceOverview(key: ObjectKey(space)),
          Space.voting => VotingOverview(key: ObjectKey(space)),
          Space.fundedProjects => FundedProjectsOverview(key: ObjectKey(space)),
        };
      },
      separatorBuilder: (context, index) => SizedBox(width: 16),
      itemCount: Space.values.length,
    );
  }
}
