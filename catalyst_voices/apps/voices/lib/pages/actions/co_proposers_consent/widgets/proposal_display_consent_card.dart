import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/display_consent_choice_menu.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/display_consent_last_update_text.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/display_consent_proposal_info.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/invited_by_text.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalDisplayConsentCard extends StatelessWidget {
  final CollaboratorProposalDisplayConsent proposalDisplayConsent;
  final ValueChanged<CollaboratorDisplayConsentStatus> onSelected;
  final VoidCallback? onTap;

  const ProposalDisplayConsentCard({
    super.key,
    required this.proposalDisplayConsent,
    required this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurfaceNeutral016,
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DisplayConsentProposalInfo(
                        categoryName: proposalDisplayConsent.categoryName,
                        proposalTitle: proposalDisplayConsent.title,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 4,
                        children: [
                          DisplayConsentChoiceMenu(
                            selectedStatus: proposalDisplayConsent.status,
                            onSelected: onSelected,
                          ),
                          DisplayConsentLastUpdateText(
                            date: proposalDisplayConsent.lastDisplayConsentUpdate,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InvitedByText(catalystId: proposalDisplayConsent.originalAuthor, invitedAt: proposalDisplayConsent.invitedAt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
