import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final _description = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

class VoicesProposalCardExample extends StatelessWidget {
  static const String route = '/proposal-card-example';

  const VoicesProposalCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proposal Card')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ProposalCard(
              image: VoicesAssets.images.proposalBackground1,
              proposal: FundedProposalViewModel(
                data: FundedProposal(
                  id: 'f14/1',
                  campaignName: 'F14',
                  category: 'Cardano Use Cases / MVP',
                  title: 'Proposal Title that rocks the world',
                  fundedDate: DateTime(2025, 1, 28),
                  fundsRequested: Coin.fromAda(100000),
                  commentsCount: 0,
                  description: _description,
                ),
              ),
            ),
            ProposalCard(
              image: VoicesAssets.images.proposalBackground2,
              proposal: PendingProposalViewModel(
                data: PendingProposal(
                  id: 'f14/2',
                  campaignName: 'F14',
                  category: 'Cardano Use Cases / MVP',
                  title: 'Proposal Title that rocks the world',
                  lastUpdateDate: DateTime.now().minusDays(2),
                  fundsRequested: Coin.fromAda(100000),
                  commentsCount: 0,
                  description: _description,
                  completedSegments: 7,
                  totalSegments: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
