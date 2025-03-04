import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/small_proposal_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiscoveryOverview extends StatelessWidget {
  const DiscoveryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        children: [
          SpaceOverviewHeader(Space.discovery),
          _DiscoveryDashboardTile(),
          _FeedbackTile(),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _PublishedProposalSelector(1, 5),
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
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) {
        return state.account?.isProposer ?? false;
      },
      builder: (context, state) {
        return Visibility.maintain(
          visible: state,
          child: SpaceOverviewNavTile(
            leading: VoicesAssets.icons.documentText.buildIcon(),
            title: Text(
              context.l10n.feedbackOnProposals,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: state
                ? () => GoRouter.of(context).go(const ProposalsRoute().location)
                : null,
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final int currentProposals;
  final int maxProposals;
  const _Header({
    required this.maxProposals,
    required this.currentProposals,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18)
        ..add(
          const EdgeInsets.only(left: 16),
        ),
      child: Text(
        context.l10n.noPublishedProposalsOnMaxCount(
          currentProposals,
          maxProposals,
        ),
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
    );
  }
}

class _PublishedProposals extends StatelessWidget {
  final int currentProposals;
  final int maxProposals;
  const _PublishedProposals(
    this.currentProposals,
    this.maxProposals,
  );

  @override
  Widget build(BuildContext context) {
    // TODO(LynxLynxx): replace with real data
    final proposal = Proposal(
      id: '1',
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
      document: ProposalDocument(
        metadata: ProposalMetadata(selfRef: DraftRef.generateFirstRef()),
        document: const Document(
          schema: DocumentSchema.optional(),
          properties: [],
        ),
      ),
      version: 1,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          maxProposals: maxProposals,
          currentProposals: currentProposals,
        ),
        SmallProposalCard(
          proposal: proposal.copyWith(
            publish: ProposalPublish.submittedProposal,
            commentsCount: 1,
          ),
        ),
        const SizedBox(height: 12),
        SmallProposalCard(
          proposal: proposal.copyWith(
            publish: ProposalPublish.publishedDraft,
            commentsCount: 12,
          ),
        ),
      ],
    );
  }
}

class _PublishedProposalSelector extends StatelessWidget {
  final int currentProposals;
  final int maxProposals;
  const _PublishedProposalSelector(
    this.currentProposals,
    this.maxProposals,
  );

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) {
        return !(state.account?.isProposer ?? false);
      },
      builder: (context, state) {
        return Offstage(
          offstage: state,
          child: _PublishedProposals(
            currentProposals,
            maxProposals,
          ),
        );
      },
    );
  }
}
