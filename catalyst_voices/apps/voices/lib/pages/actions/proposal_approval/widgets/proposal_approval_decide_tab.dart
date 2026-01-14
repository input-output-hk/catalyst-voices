import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_decide_card.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_empty_state.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalDecideTab extends StatelessWidget {
  final List<UsersProposalOverview> items;

  const ProposalApprovalDecideTab({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ProposalApprovalEmptyState(
        title: context.l10n.proposalApprovalDecideEmptyTitle,
        description: context.l10n.proposalApprovalDecideEmptyDescription,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];

        return ProposalApprovalDecideCard(
          key: ValueKey(item.id),
          proposal: item,
        );
      },
    );
  }
}
