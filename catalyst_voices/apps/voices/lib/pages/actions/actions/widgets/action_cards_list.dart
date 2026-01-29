import 'package:catalyst_voices/pages/actions/actions/widgets/become_community_reviewer_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/collaborator_display_consent_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/proposal_approval_card.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionCardsList extends StatelessWidget {
  const ActionCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyActionsCubit, MyActionsState, IterableData<List<ActionsCardType>>>(
      selector: (state) => IterableData(state.availableCards),
      builder: (context, availableCards) {
        if (availableCards.value.isEmpty) {
          return const _EmptyState();
        }

        final cards = [
          for (final cardType in availableCards.value) ?_buildCardForType(cardType),
        ];

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
      RepresentativeCardType() => null, // TODO(LynxLynxx): Implement representative card
      VotingPowerDelegationCardType() => null, // TODO(LynxLynxx): Implement voting power card
      BecomeReviewerCardType() => const BecomeCommunityReviewerCard(),
    };
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      // TODO(LynxLynxx): update empty state design after design will be provided
      child: EmptyState(
        title: const Text('There are no actions available at the moment'),
        image: VoicesAssets.images.svg.noVotes.buildPicture(),
      ),
    );
  }
}
