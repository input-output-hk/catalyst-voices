import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/pages/workspace/widgets/user_proposals/user_proposal_section.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

class UserProposals extends StatelessWidget {
  const UserProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.showProposals,
      builder: (context, show) {
        if (!show) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return const _UserProposals();
      },
    );
  }
}

class _UserDraftProposals extends StatelessWidget {
  const _UserDraftProposals();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, UserProposalsView>(
      selector: (state) {
        return state.userProposals.draftProposals;
      },
      builder: (context, proposals) {
        return UserProposalSection(
          items: proposals.items,
          emptyTextMessage: context.l10n.noDraftUserProposals,
          title: context.l10n.sharedForPublicInProgress,
          info: context.l10n.sharedForPublicInfoMarkdown,
          learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
        );
      },
    );
  }
}

class _UserInactiveProposals extends StatelessWidget {
  const _UserInactiveProposals();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, UserProposalsView>(
      selector: (state) {
        return state.userProposals.inactiveProposals;
      },
      builder: (context, proposals) {
        if (proposals.items.isEmpty) {
          return const SliverToBoxAdapter();
        }
        return UserProposalSection(
          items: proposals.items,
          emptyTextMessage: '',
          title: context.l10n.notActiveCampaign,
          info: context.l10n.notActiveCampaignInfoMarkdown,
        );
      },
    );
  }
}

class _UserLocalProposals extends StatelessWidget {
  const _UserLocalProposals();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, UserProposalsView>(
      selector: (state) {
        return state.userProposals.localProposals;
      },
      builder: (context, proposals) {
        return UserProposalSection(
          items: proposals.items,
          emptyTextMessage: context.l10n.noLocalUserProposals,
          title: context.l10n.notPublished,
          info: context.l10n.notPublishedInfoMarkdown,
          learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
        );
      },
    );
  }
}

class _UserProposals extends StatelessWidget {
  const _UserProposals();

  @override
  Widget build(BuildContext context) {
    return const SliverMainAxisGroup(
      slivers: <Widget>[
        _UserSubmittedProposals(),
        _UserDraftProposals(),
        _UserLocalProposals(),
        _UserInactiveProposals(),
      ],
    );
  }
}

class _UserSubmittedProposals extends StatelessWidget {
  const _UserSubmittedProposals();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, UserProposalsView>(
      selector: (state) {
        return state.userProposals.finalProposals;
      },
      builder: (context, proposals) {
        return UserProposalSection(
          items: proposals.items,
          emptyTextMessage: context.l10n.noFinalUserProposals,
          title: context.l10n.submittedForReview(
            proposals.items.length,
            ProposalDocument.maxSubmittedProposalsPerUser,
          ),
          info: context.l10n.submittedForReviewInfoMarkdown,
          learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
        );
      },
    );
  }
}
