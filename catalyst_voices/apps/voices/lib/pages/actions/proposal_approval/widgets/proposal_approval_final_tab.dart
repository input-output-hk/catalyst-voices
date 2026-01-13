import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_empty_state.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalFinalCard extends StatelessWidget {
  final List<Contributor> contributors;

  const ProposalApprovalFinalCard({
    super.key,
    required this.contributors,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProposalApprovalFinalTab extends StatelessWidget {
  final List<dynamic> items;

  const ProposalApprovalFinalTab({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ProposalApprovalEmptyState(
        title: context.l10n.proposalApprovalFinalProposalsEmptyTitle,
        description: context.l10n.proposalApprovalFinalProposalsEmptyDescription,
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];

        return const ProposalApprovalFinalCard(
          // key: ValueKey(item.id),
          contributors: [],
        );
      },
    );
  }
}
