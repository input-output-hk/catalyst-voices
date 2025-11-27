import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/error_user_proposal_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/loading_user_proposal_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/user_proposals_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/user_proposals_overview_list.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceOverviewProposal extends StatelessWidget {
  const WorkspaceOverviewProposal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        LoadingProposalOverview(),
        ErrorProposalOverview(),
        _WorkspaceDataProposalOverview(),
      ],
    );
  }
}

class _WorkspaceDataProposalOverview extends StatelessWidget {
  const _WorkspaceDataProposalOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProposalsOverviewHeader(title: context.l10n.notPublishedProposals),
        BlocSelector<WorkspaceBloc, WorkspaceState, DataVisibilityState<UserProposalsView>>(
          selector: (state) {
            return (
              data: state.userProposals.notPublished,
              show: state.showProposals && !state.isLoading,
            );
          },
          builder: (context, state) {
            return Offstage(
              offstage: !state.show,
              child: UserProposalsOverviewList(
                proposals: state.data.items,
                emptyMessage: context.l10n.noProposalsToPublish,
                showLatestLocal: true,
              ),
            );
          },
        ),
      ],
    );
  }
}
