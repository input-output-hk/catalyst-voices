import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_selectors/user_proposal_selectors.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceOverview extends StatelessWidget {
  const WorkspaceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpaceOverviewHeader(Space.workspace),
          _BrowseMyProposals(),
          SizedBox(height: 56),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _NotPublishedProposalSelector(),
            ),
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
      onTap: () => const MyProposalsRoute().go(context),
    );
  }
}

class _NotPublishedProposalSelector extends StatelessWidget {
  const _NotPublishedProposalSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) {
        return !(state.account?.isProposer ?? false);
      },
      builder: (context, state) {
        return Offstage(
          offstage: state,
          child: const WorkspaceOverviewProposalSelector(),
        );
      },
    );
  }
}
