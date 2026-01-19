import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/proposal/small_proposal_card.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class UserProposalsOverviewList extends StatelessWidget {
  final List<UsersProposalOverview> proposals;
  final String emptyMessage;
  final bool showLatestLocal;

  const UserProposalsOverviewList({
    super.key,
    required this.proposals,
    required this.emptyMessage,
    this.showLatestLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (proposals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          emptyMessage,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      );
    }
    return Column(
      spacing: 12,
      children: proposals
          .map(
            (e) => SmallProposalCard(
              proposal: e,
              showLatestLocal: showLatestLocal,
            ),
          )
          .toList(),
    );
  }
}
