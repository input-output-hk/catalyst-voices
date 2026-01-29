import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_pagination.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_search.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_sub_header.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_tabs.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_tabs_divider.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_results_content.dart';
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
        _TabBar(tabController: tabController),
        const VotingProposalsTabsDivider(),
        const SizedBox(height: 32),
        _ContentBody(
          tabController: tabController,
          pagingController: pagingController,
        ),
      ],
    );
  }
}

class _ContentBody extends StatelessWidget {
  final VoicesTabController<VotingPageTab> tabController;
  final PagingController<ProposalBrief> pagingController;

  const _ContentBody({
    required this.tabController,
    required this.pagingController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tabController,
      builder: (context, child) {
        return tabController.tab == VotingPageTab.results
            ? const VotingResultsContent()
            : VotingProposalsPagination(controller: pagingController);
      },
    );
  }
}

class _TabBar extends StatelessWidget {
  final VoicesTabController<VotingPageTab> tabController;

  const _TabBar({
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListenableBuilder(
        listenable: tabController,
        builder: (context, child) {
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            runSpacing: 10,
            children: [
              Padding(
                // top padding to align the tabs with the search bar.
                padding: const EdgeInsets.only(top: 16),
                child: VotingProposalsTabs(controller: tabController),
              ),
              if (tabController.tab != VotingPageTab.results) const VotingProposalsSearch(),
            ],
          );
        },
      ),
    );
  }
}
