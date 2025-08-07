import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_empty_state.dart';
import 'package:catalyst_voices/pages/voting/widgets/grid/voting_proposals_pagination_tile.dart';
import 'package:catalyst_voices/widgets/pagination/builders/paged_wrap_child_builder.dart';
import 'package:catalyst_voices/widgets/pagination/layouts/paginated_grid_view.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingProposalsPagination extends StatelessWidget {
  final PagingController<ProposalBriefVoting> controller;

  const VotingProposalsPagination({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedGridView<ProposalBriefVoting>(
      pagingController: controller,
      builderDelegate: PagedWrapChildBuilder<ProposalBriefVoting>(
        builder: (context, item) {
          return VotingProposalsPaginationTile(
            key: ValueKey(item.selfRef),
            proposal: item,
          );
        },
        emptyIndicatorBuilder: (_) => const VotingProposalsEmptyState(),
      ),
    );
  }
}
