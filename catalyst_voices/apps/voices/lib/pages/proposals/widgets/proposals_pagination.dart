import 'package:catalyst_voices/pages/proposals/widgets/proposals_pagination_empty_state.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_pagination_tile.dart';
import 'package:catalyst_voices/widgets/pagination/builders/paged_wrap_child_builder.dart';
import 'package:catalyst_voices/widgets/pagination/layouts/paginated_grid_view.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsPagination extends StatelessWidget {
  final PagingController<ProposalBrief> controller;

  const ProposalsPagination({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedGridView<ProposalBrief>(
      pagingController: controller,
      builderDelegate: PagedWrapChildBuilder<ProposalBrief>(
        builder: (context, item) {
          return ProposalsPaginationTile(
            key: ValueKey(item.id),
            proposal: item,
          );
        },
        emptyIndicatorBuilder: (_) => const DiscoveryProposalsEmptyState(),
      ),
    );
  }
}
