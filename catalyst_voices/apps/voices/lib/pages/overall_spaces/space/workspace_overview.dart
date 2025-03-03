import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkspaceOverview extends StatelessWidget {
  const WorkspaceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        children: [
          SpaceOverviewHeader(Space.workspace),
          _BrowseMyProposals(),
          SizedBox(height: 56),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
          SectionHeader(title: Text('My private proposals (3/5)')),
          VoicesNavTile(
            name: 'My first proposal',
            status: ProposalStatus.draft,
            trailing: MoreOptionsButton(),
          ),
          VoicesNavTile(
            name: 'My second proposal',
            status: ProposalStatus.ready,
            trailing: MoreOptionsButton(),
          ),
          VoicesNavTile(
            name: 'My third proposal',
            status: ProposalStatus.ready,
            trailing: MoreOptionsButton(),
          ),
        ],
      ),
    );
  }
}

class _BrowseMyProposals extends StatelessWidget {
  const _BrowseMyProposals();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.briefcase.buildIcon(),
      title: Text(
        context.l10n.browseMyProposals,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () => GoRouter.of(context).go(const MyProposalsRoute().location),
    );
  }
}
