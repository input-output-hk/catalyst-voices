import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

class ProposalRepository {
  const ProposalRepository();

  /// Fetches all proposals.
  Future<List<Proposal>> getProposals({
    required String campaignId,
  }) async {
    // simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));
    // optionally filter by status.
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
  Proposal(
    id: 'f14/0',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.draft,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    sections: List.generate(13, (index) {
      return ProposalSection(
        id: 'f14/0_$index',
        name: 'Section_$index',
        steps: [
          ProposalSectionStep(
            id: 'f14/0_${index}_1',
            name: 'Topic 1',
          ),
        ],
      );
    }),
  ),
  Proposal(
    id: 'f14/1',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.draft,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    sections: List.generate(13, (index) {
      return ProposalSection(
        id: 'f14/0_$index',
        name: 'Section_$index',
        steps: [
          ProposalSectionStep(
            id: 'f14/0_${index}_1',
            name: 'Topic 1',
            answer: index < 7 ? const MarkdownData('Ans') : null,
          ),
        ],
      );
    }),
  ),
  Proposal(
    id: 'f14/2',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.draft,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    sections: List.generate(13, (index) {
      return ProposalSection(
        id: 'f14/0_$index',
        name: 'Section_$index',
        steps: [
          ProposalSectionStep(
            id: 'f14/0_${index}_1',
            name: 'Topic 1',
            answer: const MarkdownData('Ans'),
          ),
        ],
      );
    }),
  ),
];
