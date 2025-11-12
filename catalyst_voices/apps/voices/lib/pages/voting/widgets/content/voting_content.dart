import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_pagination.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_search.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_sub_header.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_tabs.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_tabs_divider.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingContent extends StatelessWidget {
  final VoicesTabController<VotingPageTab> tabController;
  final PagingController<ProposalBrief> pagingController;

  const VotingContent({
    super.key,
    required this.tabController,
    required this.pagingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const VotingProposalsSubHeader(),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            runSpacing: 10,
            children: [
              VotingProposalsTabs(controller: tabController),
              const VotingProposalsSearch(),
            ],
          ),
        ),
        const VotingProposalsTabsDivider(),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        VotingProposalsPagination(controller: pagingController),
      ],
    );
  }
}
