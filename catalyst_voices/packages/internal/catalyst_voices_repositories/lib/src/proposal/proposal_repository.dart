import 'dart:math';

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
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
    required String campaignId,
  });

  Future<List<String>> getFavoritesProposalsIds();

  Future<List<String>> getUserProposalsIds(String userId);
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
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
    required String campaignId,
  }) async {
    // optionally filter by status.
    final proposals = <ProposalBase>[];

    // Return users proposals match his account id with proposals metadata from
    // author field.
    if (request.usersProposals) {
      return const ProposalsSearchResult(maxResults: 0, proposals: []);
    } else if (request.usersFavorite) {
      return const ProposalsSearchResult(maxResults: 0, proposals: []);
    }

    for (var i = 0; i < request.pageSize; i++) {
      // ignore: lines_longer_than_80_chars
      final stage = Random().nextBool()
          ? ProposalPublish.published
          : ProposalPublish.draft;
      proposals.add(
        ProposalBase(
          id: '${Random().nextInt(1000)}/${Random().nextInt(1000)}',
          category: 'Cardano Use Cases / MVP',
          title: 'Proposal Title that rocks the world',
          updateDate: DateTime.now().minusDays(2),
          fundsRequested: Coin.fromAda(100000),
          status: ProposalStatus.draft,
          publish: request.stage ?? stage,
          access: ProposalAccess.private,
          commentsCount: 0,
          description: _proposalDescription,
          duration: 6,
          author: 'Alex Wells',
          version: 1,
        ),
      );
    }

    return ProposalsSearchResult(
      maxResults: _maxResults(request.stage),
      proposals: proposals,
    );
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    // TODO(LynxLynxx): read db to get favorites proposals ids
    return <String>[];
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    // TODO(LynxLynxx): read db to get user's proposals
    return <String>[];
  }
}

// TODO(LynxLynxx): remove after implementing reading db
int _maxResults(ProposalPublish? stage) {
  if (stage == null) {
    return 64;
  }
  if (stage == ProposalPublish.published) {
    return 48;
  }
  return 32;
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
    id: '${Random().nextInt(1000)}1',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.draft,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 1,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}2',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.draft,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 2,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}3',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.draft,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 3,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}4',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.published,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 3,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}5',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.published,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 3,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}6',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.published,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 3,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}7',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.published,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 3,
  ),
  ProposalBase(
    id: '${Random().nextInt(1000)}8',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    updateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    status: ProposalStatus.draft,
    publish: ProposalPublish.published,
    access: ProposalAccess.private,
    commentsCount: 0,
    description: _proposalDescription,
    duration: 6,
    author: 'Alex Wells',
    version: 3,
  ),
];
