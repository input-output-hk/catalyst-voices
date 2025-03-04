import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// ignore: one_member_abstracts
abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
  ) = ProposalServiceImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  /// Delete a draft proposal from local storage.
  ///
  /// Published proposals cannot be deleted.
  Future<void> deleteDraftProposal(DraftRef ref);

  /// Encodes the [content] to exportable format.
  ///
  /// It does not save the document anywhere on the disk,
  /// it only encodes a document as [Uint8List]
  /// so that it can be saved as a file.
  Future<Uint8List> encodeProposalForExport({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  });

  /// Fetches favorites proposals ids of the user
  Future<List<String>> getFavoritesProposalsIds();

  Future<Proposal> getProposal({
    required DocumentRef ref,
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

  /// Imports the proposal from [data] encoded by [encodeProposalForExport].
  ///
  /// The proposal reference will be altered to avoid linking
  /// the imported proposal to the old proposal.
  ///
  /// Once imported from the version management point of view this becomes
  /// a new standalone proposal not related to the previous one.
  Future<DocumentRef> importProposal(Uint8List data);

  /// Publishes a public proposal draft.
  Future<void> publishProposal(Document document);

  Future<List<String>> removeFavoriteProposal(String proposalId);

  /// Submits a proposal draft into review.
  Future<void> submitProposalForReview(Document document);

  /// Saves a new proposal draft in the local storage.
  Future<void> updateDraftProposal({
    required DraftRef ref,
    required DocumentDataContent content,
  });
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
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(ref: ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  }) {
    return _documentRepository.encodeDocumentForExport(
      metadata: metadata,
      content: content,
    );
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    final proposalsIds = await _proposalRepository.getFavoritesProposalsIds();
    return proposalsIds;
  }

  @override
  Future<Proposal> getProposal({
    required DocumentRef ref,
  }) async {
    final proposalBase = await _proposalRepository.getProposal(ref: ref);
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
  Future<DocumentRef> importProposal(Uint8List data) {
    return _documentRepository.importDocument(data: data);
  }

  @override
  Future<void> publishProposal(Document document) {
    // TODO(dtscalac): implement publishing proposals
    throw UnimplementedError();
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    return _proposalRepository.removeFavoriteProposal(proposalId);
  }

  @override
  Future<void> submitProposalForReview(Document document) {
    // TODO(dtscalac): implement submitting proposals into review
    throw UnimplementedError();
  }

  @override
  Future<void> updateDraftProposal({
    required DraftRef ref,
    required DocumentDataContent content,
  }) {
    return _documentRepository.updateDocumentDraft(
      ref: ref,
      content: content,
    );
  }

  Future<Proposal> _buildProposal(ProposalBase base) async {
    final proposalDocument = await _documentRepository.getProposalDocument(
      ref: base.ref,
    );

    return base.toProposal(document: proposalDocument);
  }
}
