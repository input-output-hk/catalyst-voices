import 'package:catalyst_voices/pages/proposals/widgets/proposals_controls.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_pagination.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_sub_header.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_tabs_divider.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsContent extends StatelessWidget {
  final TabController tabController;
  final PagingController<ProposalBrief> pagingController;

  const ProposalsContent({
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
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            runSpacing: 10,
            children: [
              ProposalsTabs(controller: tabController),
              const ProposalsControls(),
            ],
          ),
        ),
        const ProposalsTabsDivider(),
        const SizedBox(height: 16),
        const ProposalsSubHeader(),
        const SizedBox(height: 16),
        ProposalsPagination(controller: pagingController),
      ],
    );
  }
}
