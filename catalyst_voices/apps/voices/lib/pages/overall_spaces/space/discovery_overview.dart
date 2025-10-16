import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/discovery_overview_proposal.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoveryOverview extends StatelessWidget {
  const DiscoveryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpaceOverviewHeader(Space.discovery),
          _DiscoveryDashboardTile(),
          _FeedbackTile(),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _PublishedProposal(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryDashboardTile extends StatelessWidget {
  const _DiscoveryDashboardTile();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.home.buildIcon(),
      title: Text(
        context.l10n.discoveryHomepage,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () => GoRouter.of(context).go(const DiscoveryRoute().location),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.documentText.buildIcon(),
      title: Text(
        context.l10n.feedbackOnProposals,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () => const ProposalsRoute().go(context),
    );
  }
}

class _PublishedProposal extends StatelessWidget {
  const _PublishedProposal();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) {
        return !(state.account?.isProposer ?? false);
      },
      builder: (context, state) {
        return Offstage(
          offstage: state,
          child: const DiscoveryOverviewProposal(),
        );
      },
    );
  }
}
