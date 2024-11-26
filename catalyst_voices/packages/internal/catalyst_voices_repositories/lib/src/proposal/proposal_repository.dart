import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

class ProposalRepository {
  const ProposalRepository();

  /// Fetches all draft proposals.
  Future<List<PendingProposal>> getDraftProposals() async {
    // simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));
    return _proposals;
  }
}

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

final _proposals = [
  PendingProposal(
    id: 'f14/0',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 0,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/1',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 7,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/2',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 13,
    totalSegments: 13,
  ),
];
