import 'package:catalyst_voices/pages/actions/actions/widgets/collaborator_display_consent_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/proposal_approval_card.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionCardsList extends StatelessWidget {
  final ActionsPageTab selectedTab;

  const ActionCardsList({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final cards = _getCardsForTab(selectedTab);

    if (cards.isEmpty) {
      return const _EmptyState();
    }

    return SliverList.separated(
      itemCount: cards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }

  // TODO(LynxLynxx): Move card creation logic to cubit if changing cards dynamically will be required
  Widget? _buildCardForType(ActionsCardType cardType) {
    return switch (cardType) {
      ActionsCardType.proposalApproval => const ProposalApprovalCard(),
      ActionsCardType.displayConsent => const CollaboratorDisplayConsentCard(),
      ActionsCardType.representative => null, // TODO(LynxLynxx): Implement representative card
      ActionsCardType.votingPower => null, // TODO(LynxLynxx): Implement voting power card
    };
  }

  List<Widget> _getCardsForTab(ActionsPageTab tab) {
    final matchingCardTypes = tab == ActionsPageTab.all
        ? ActionsCardType.values
        : ActionsCardType.values.where((cardType) => cardType.associatedTab == tab).toList();

    return [
      for (final cardType in matchingCardTypes) ?_buildCardForType(cardType),
    ];
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
