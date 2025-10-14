import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/user_proposals/user_proposal_section.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

class UserProposals extends StatelessWidget {
  const UserProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          _Divider(),
          SizedBox(height: 20),
          _UserSubmittedProposals(
            key: Key('UsersSubmittedProposalsList'),
          ),
          _UserDraftProposals(
            key: Key('UsersDraftProposalsList'),
          ),
          _UserLocalProposals(
            key: Key('UsersLocalProposalsList'),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return VoicesDivider(
      indent: 0,
      endIndent: 0,
      height: 24,
      color: context.colorScheme.primary,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.myProposals,
      style: context.textTheme.headlineSmall,
    );
  }
}

class _UserDraftProposals extends StatelessWidget {
  const _UserDraftProposals({super.key});

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

class _UserLocalProposals extends StatelessWidget {
  const _UserLocalProposals({super.key});

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

class _UserSubmittedProposals extends StatelessWidget {
  const _UserSubmittedProposals({super.key});

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
