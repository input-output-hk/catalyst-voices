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
  final BorderRadius borderRadius;

  const ProposalDisplayConsentCard({
    super.key,
    required this.proposalDisplayConsent,
    required this.onSelected,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurfaceNeutral016,
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProposalConsentInfo(
                  categoryName: proposalDisplayConsent.categoryName,
                  proposalTitle: proposalDisplayConsent.title,
                  selectedStatus: proposalDisplayConsent.status,
                  lastDisplayConsentUpdate: proposalDisplayConsent.lastDisplayConsentUpdate,
                  onSelected: onSelected,
                ),
                InvitedByText(
                  catalystId: proposalDisplayConsent.originalAuthor,
                  invitedAt: proposalDisplayConsent.invitedAt,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProposalConsentInfo extends StatelessWidget {
  final String categoryName;
  final String proposalTitle;
  final CollaboratorDisplayConsentStatus selectedStatus;
  final DateTime? lastDisplayConsentUpdate;
  final ValueChanged<CollaboratorDisplayConsentStatus> onSelected;

  const _ProposalConsentInfo({
    required this.categoryName,
    required this.proposalTitle,
    required this.selectedStatus,
    required this.lastDisplayConsentUpdate,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: DisplayConsentProposalInfo(
            categoryName: categoryName,
            proposalTitle: proposalTitle,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              DisplayConsentChoiceMenu(
                selectedStatus: selectedStatus,
                onSelected: onSelected,
              ),
              DisplayConsentLastUpdateText(
                date: lastDisplayConsentUpdate,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
