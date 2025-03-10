import 'dart:math';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:uuid/uuid.dart';

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

// TODO(LynxLynxx): remove after implementing reading db
int _maxResults(ProposalPublish? stage) {
  if (stage == null) {
    return 64;
  }
  if (stage == ProposalPublish.submittedProposal) {
    return 48;
  }
  return 32;
}

abstract interface class ProposalRepository {
  const factory ProposalRepository() = ProposalRepositoryImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  Future<List<String>> getFavoritesProposalsIds();

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  /// Fetches all proposals.
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
  });

  Future<List<String>> getUserProposalsIds(String userId);

  Future<List<String>> removeFavoriteProposal(String proposalId);
}

final class ProposalRepositoryImpl implements ProposalRepository {
  const ProposalRepositoryImpl();

  @override
  Future<List<String>> addFavoriteProposal(String proposalId) async {
    // TODO(LynxLynxx): add proposal to favorites
    return getFavoritesProposalsIds();
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    // TODO(LynxLynxx): read db to get favorites proposals ids
    return <String>[];
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    return ProposalData(
      categoryId: const Uuid().v7(),
      document: ProposalDocument(
        metadata: ProposalMetadata(selfRef: ref),
        document: const Document(
          properties: [],
          schema: DocumentSchema.optional(),
        ),
      ),
      ref: ref,
    );
  }

  @override
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    // optionally filter by status.
    final proposals = <Proposal>[];

    // Return users proposals match his account id with proposals metadata from
    // author field.
    if (request.usersProposals) {
      return _getUserProposalsSearchResult(request);
    } else if (request.usersFavorite) {
      return _getFavoritesProposalsSearchResult(request);
    }

    for (var i = 0; i < request.pageSize; i++) {
      // ignore: lines_longer_than_80_chars
      final stage = Random().nextBool()
          ? ProposalPublish.submittedProposal
          : ProposalPublish.publishedDraft;
      proposals.add(
        Proposal(
          selfRef: SignedDocumentRef.generateFirstRef(),
          category: 'Cardano Use Cases / MVP',
          title: 'Proposal Title that rocks the world',
          updateDate: DateTime.now().minusDays(2),
          fundsRequested: Coin.fromAda(100000),
          status: ProposalStatus.draft,
          publish: request.stage ?? stage,
          commentsCount: 0,
          description: _proposalDescription,
          duration: 6,
          author: 'Alex Wells',
          versionCount: 1,
        ),
      );
    }

    return ProposalsSearchResult(
      maxResults: _maxResults(request.stage),
      proposals: proposals,
    );
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    // TODO(LynxLynxx): read db to get user's proposals
    return <String>[];
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    // TODO(LynxLynxx): remove proposal from favorites
    return getFavoritesProposalsIds();
  }

  Future<ProposalsSearchResult> _getFavoritesProposalsSearchResult(
    ProposalPaginationRequest request,
  ) async {
    final favoritesIds = await getFavoritesProposalsIds();
    final proposals = <Proposal>[];
    final range = PagingRange.calculateRange(
      pageKey: request.pageKey,
      itemsPerPage: request.pageSize,
      maxResults: favoritesIds.length,
    );
    if (favoritesIds.isEmpty) {
      return const ProposalsSearchResult(
        maxResults: 0,
        proposals: [],
      );
    }
    for (var i = range.from; i <= range.to; i++) {
      final ref = SignedDocumentRef(id: favoritesIds[i]);
      final proposalData = await getProposal(ref: ref);
      final proposal = Proposal.fromData(proposalData);
      proposals.add(proposal);
    }

    return ProposalsSearchResult(
      maxResults: favoritesIds.length,
      proposals: proposals,
    );
  }

  Future<ProposalsSearchResult> _getUserProposalsSearchResult(
    ProposalPaginationRequest request,
  ) async {
    final userProposalsIds = await getUserProposalsIds('');
    final proposals = <Proposal>[];
    final range = PagingRange.calculateRange(
      pageKey: request.pageKey,
      itemsPerPage: request.pageSize,
      maxResults: userProposalsIds.length,
    );
    if (userProposalsIds.isEmpty) {
      return const ProposalsSearchResult(
        maxResults: 0,
        proposals: [],
      );
    }
    for (var i = range.from; i <= range.to; i++) {
      final ref = SignedDocumentRef(id: userProposalsIds[i]);
      final proposalData = await getProposal(ref: ref);
      final proposal = Proposal.fromData(proposalData);
      proposals.add(proposal);
    }

    return ProposalsSearchResult(
      maxResults: userProposalsIds.length,
      proposals: proposals,
    );
  }
}
