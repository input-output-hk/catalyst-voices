import 'package:catalyst_voices/widgets/widgets.dart' show ProposalBriefCard;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final _description =
    """
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
            ProposalBriefCard(
              proposal: ProposalBrief(
                id: SignedDocumentRef.generateFirstRef(),
                categoryName: 'Cardano Use Cases / MVP',
                title: 'Proposal Title that rocks the world',
                fundsRequested: Money.fromMajorUnits(
                  currency: Currencies.ada,
                  majorUnits: BigInt.from(100000),
                ),
                commentsCount: 0,
                publish: ProposalPublish.publishedDraft,
                versionNumber: 1,
                duration: 6,
                updateDate: DateTime.now(),
                description: _description,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
