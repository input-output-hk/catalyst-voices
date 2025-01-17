import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

// ignore: one_member_abstracts
abstract interface class ProposalRepository {
  const factory ProposalRepository() = ProposalRepositoryImpl;

  Future<ProposalBase> getProposal({
    required String id,
  });

  /// Fetches all proposals.
  Future<List<ProposalBase>> getProposals({
    required String campaignId,
  });
}

final class ProposalRepositoryImpl implements ProposalRepository {
  const ProposalRepositoryImpl();

  @override
  Future<ProposalBase> getProposal({
    required String id,
  }) async {
    return _proposals.first;
  }

  @override
  Future<List<ProposalBase>> getProposals({
    required String campaignId,
  }) async {
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
  ProposalBase(
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
  ),
  ProposalBase(
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
  ),
  ProposalBase(
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
  ),
];
