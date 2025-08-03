import 'package:catalyst_voices/widgets/empty_state/specialized/proposals_pagination_empty_state.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingProposalsPaginationEmptyStateSelector extends StatelessWidget {
  const VotingProposalsPaginationEmptyStateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, bool>(
      selector: (state) => state.hasSearchQuery,
      builder: (context, state) {
        return ProposalsPaginationEmptyState(hasSearchQuery: state);
      },
    );
  }
}
