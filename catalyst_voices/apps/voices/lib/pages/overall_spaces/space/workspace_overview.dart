import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/cards/small_proposal_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      onTap: () => GoRouter.of(context).go(const MyProposalsRoute().location),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18)
        ..add(
          const EdgeInsets.only(left: 16),
        ),
      child: Text(
        context.l10n.notPublishedProposals,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
    );
  }
}

class _NotPublishedProposals extends StatelessWidget {
  const _NotPublishedProposals();

  @override
  Widget build(BuildContext context) {
    // TODO(LynxLynxx): replace with real data
    final proposal = Proposal(
      selfRef: SignedDocumentRef.generateFirstRef(),
      title: 'Latest proposal that is making its rounds.',
      category: 'F14: Cardano Use Cases: Concept',
      description: 'Lorem ipsum dolor sit ',
      fundsRequested: const Coin(100000),
      status: ProposalStatus.draft,
      publish: ProposalPublish.localDraft,
      commentsCount: 0,
      duration: 6,
      author: 'Alex Wells',
      updateDate: DateTime.now(),
      
      versionCount: 1,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        SmallProposalCard(
          proposal: proposal,
        ),
      ],
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
          child: const _NotPublishedProposals(),
        );
      },
    );
  }
}
