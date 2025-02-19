import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// ignore: one_member_abstracts
abstract interface class ProposalService {
  factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
  ) {
    return ProposalServiceImpl(
      proposalRepository,
      documentRepository,
    );
  }

  Future<List<String>> addFavoriteProposal(String proposalId);

  /// Fetches favorites proposals ids of the user
  Future<List<String>> getFavoritesProposalsIds();

  Future<Proposal> getProposal({
    required String id,
  });

  Future<ProposalPaginationItems<Proposal>> getProposals({
    required ProposalPaginationRequest request,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  /// Fetches user's proposals ids  depending on his id that is saved
  /// in metadata of proposal document
  Future<List<String>> getUserProposalsIds(String userId);

  Future<List<String>> removeFavoriteProposal(String proposalId);
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
  );

  @override
  Future<List<String>> addFavoriteProposal(String proposalId) async {
    return _proposalRepository.addFavoriteProposal(proposalId);
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    final proposalsIds = await _proposalRepository.getFavoritesProposalsIds();
    return proposalsIds;
  }

  @override
  Future<Proposal> getProposal({
    required String id,
  }) async {
    final proposalBase = await _proposalRepository.getProposal(id: id);
    final proposal = await _buildProposal(proposalBase);

    return proposal;
  }

  @override
  Future<ProposalPaginationItems<Proposal>> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    final proposalBases = await _proposalRepository.getProposals(
      request: request,
    );

    final futures = proposalBases.proposals.map(_buildProposal);

    final proposals = await Future.wait(futures);

    return ProposalPaginationItems(
      items: proposals,
      pageKey: request.pageKey,
      maxResults: proposalBases.maxResults,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    final proposalTemplate = await _documentRepository.getProposalTemplate(
      ref: ref,
    );

    return proposalTemplate;
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    final proposalsIds = await _proposalRepository.getUserProposalsIds(userId);
    return proposalsIds;
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    return _proposalRepository.removeFavoriteProposal(proposalId);
  }

  Future<Proposal> _buildProposal(ProposalBase base) async {
    final proposalDocument = await _documentRepository.getProposalDocument(
      ref: base.ref,
    );

    return base.toProposal(document: proposalDocument);
  }
}
