import 'package:catalyst_voices/widgets/empty_state/specialized/proposals_pagination_empty_state.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DiscoveryProposalsEmptyState extends StatelessWidget {
  const DiscoveryProposalsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, bool>(
      selector: (state) => state.hasSearchQuery,
      builder: (context, state) {
        return ProposalsPaginationEmptyState(hasSearchQuery: state);
      },
    );
  }
}
