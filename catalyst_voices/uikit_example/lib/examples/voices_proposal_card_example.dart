import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
            FundedProposalCard(
              image: VoicesAssets.images.proposalBackground1,
              proposal: FundedProposal(
                fund: 'F14',
                category: 'Cardano Use Cases / MVP',
                title: 'Proposal Title that rocks the world',
                fundedDate: DateTime(2025, 1, 28),
                fundsRequested: Coin.fromAda(100000),
                commentsCount: 0,
                description: _description,
              ),
            ),
            FundedProposalCard(
              image: VoicesAssets.images.proposalBackground2,
              proposal: FundedProposal(
                fund: 'F14',
                category: 'Cardano Use Cases / MVP',
                title: 'Proposal Title that rocks the world',
                fundedDate: DateTime(2025, 1, 28),
                fundsRequested: Coin.fromAda(100000),
                commentsCount: 0,
                description: _description,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
