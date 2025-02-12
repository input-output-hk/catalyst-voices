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

  Future<Proposal> getProposal({
    required String id,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required SignedDocumentRef ref,
  });

  /// Fetches proposals for the [campaignId].
  Future<ProposalSearchResult> getProposals({
    required String campaignId,
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
  Future<Proposal> getProposal({
    required String id,
  }) async {
    final proposalBase = await _proposalRepository.getProposal(id: id);
    final proposal = await _buildProposal(proposalBase);

    return proposal;
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required SignedDocumentRef ref,
  }) async {
    final proposalTemplate = await _documentRepository.getProposalTemplate(
      ref: ref,
    );

    return proposalTemplate;
  }

  @override
  Future<ProposalSearchResult> getProposals({
    required String campaignId,
  }) async {
    final proposalBases = await _proposalRepository.getProposals(
      campaignId: campaignId,
    );

    final futures = proposalBases.map(_buildProposal);

    final proposals = await Future.wait(futures);

    // TODO(LynxLynxx): implement real search result from DB
    return ProposalSearchResult(
      proposals: proposals,
      finalProposalCount: 5 * 4,
      draftProposalCount: 3 * 4,
      myProposalCount: 0,
      favoriteProposalCount: 0,
    );
  }

  Future<Proposal> _buildProposal(ProposalBase base) async {
    final proposalDocument = await _documentRepository.getProposalDocument(
      ref: base.ref,
    );

    return base.toProposal(document: proposalDocument);
  }
}
