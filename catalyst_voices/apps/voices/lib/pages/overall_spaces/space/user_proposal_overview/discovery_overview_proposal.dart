import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/error_user_proposal_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/loading_user_proposal_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/user_proposals_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/user_proposal_overview/widgets/user_proposals_overview_list.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DiscoveryOverviewProposal extends StatelessWidget {
  const DiscoveryOverviewProposal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        LoadingProposalOverview(),
        ErrorProposalOverview(),
        _DiscoveryOverviewProposalData(),
      ],
    );
  }
}

class _DiscoveryOverviewProposalData extends StatelessWidget {
  const _DiscoveryOverviewProposalData();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          BlocSelector<
            WorkspaceBloc,
            WorkspaceState,
            DataVisibilityState<List<UsersProposalOverview>>
          >(
            selector: (state) {
              return (data: state.userProposals.published.items, show: state.showProposals);
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProposalsOverviewHeader(
                    title: context.l10n.publishedProposals,
                  ),
                  Offstage(
                    offstage: !state.show,
                    child: UserProposalsOverviewList(
                      proposals: state.data,
                      emptyMessage: context.l10n.noPublishedProposals,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
    );
  }
}
