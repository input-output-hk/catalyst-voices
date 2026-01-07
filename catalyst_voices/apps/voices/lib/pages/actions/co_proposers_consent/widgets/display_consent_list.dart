import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/proposal_display_consent_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_decorated_sliver_panel.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DisplayConsentList extends StatelessWidget {
  const DisplayConsentList({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [1, 2, 3];
    return ActionsDecoratedSliverPanel(
      sliver: SliverList.separated(
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ProposalDisplayConsentCard(
            proposalDisplayConsent: CollaboratorProposalDisplayConsent.empty(
              CollaboratorDisplayConsentStatus.values[index],
            ),
            // onTap: () => ProposalRoute(proposalId: proposalId).go(context),
            onSelected: (val) {},
          );
        },
      ),
    );
  }
}
