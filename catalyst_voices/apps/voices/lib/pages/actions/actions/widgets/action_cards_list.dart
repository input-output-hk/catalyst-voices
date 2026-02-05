import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/become_community_reviewer_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/collaborator_display_consent_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/proposal_approval_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/representative_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionCardsList extends StatelessWidget {
  const ActionCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyActionsCubit, MyActionsState, ActionCardsState>(
      selector: (state) => state.actionCardsState,
      builder: (context, actionCards) {
        final cards = [
          for (final cardType in actionCards.availableCards) ?_buildCardForType(cardType),
        ];

        if (cards.isEmpty) {
          return _EmptyState(actionCards.selectedTab);
        }

        return SliverList.separated(
          itemCount: cards.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => cards[index],
        );
      },
    );
  }

  Widget? _buildCardForType(ActionsCardType cardType) {
    return switch (cardType) {
      ProposalApprovalCardType() => const ProposalApprovalCard(),
      DisplayConsentCardType() => const CollaboratorDisplayConsentCard(),
      RepresentativeCardType() => RepresentativeCard(
        cardType: cardType,
      ),
      VotingPowerDelegationCardType() => null, // TODO(LynxLynxx): Implement voting power card
      BecomeReviewerCardType() => const BecomeCommunityReviewerCard(),
    };
  }
}

class _EmptyState extends StatelessWidget {
  final ActionsPageTab tab;

  const _EmptyState(this.tab);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 232),
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              tab.localizedEmptyStateTitle(context),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
            Text(
              tab.localizedEmptyStateDescription(context),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
