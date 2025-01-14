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

  Future<DocumentSchema> getProposalTemplate({
    required String id,
  });

  /// Fetches proposals for the [campaignId].
  Future<List<Proposal>> getProposals({
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
    // TODO: implement getProposal
    throw UnimplementedError();
  }

  @override
  Future<DocumentSchema> getProposalTemplate({
    required String id,
  }) async {
    // TODO: implement getProposalTemplate
    throw UnimplementedError();
  }

  @override
  Future<List<Proposal>> getProposals({
    required String campaignId,
  }) async {
    final proposalBases = await _proposalRepository.getProposals(
      campaignId: campaignId,
    );

    final futures = proposalBases.map(_buildProposal);

    final proposals = await Future.wait(futures);

    return proposals;
  }

  Future<Proposal> _buildProposal(ProposalBase base) async {
    final document = await _documentRepository.getDocument(
      id: base.documentId,
      version: base.documentVersion,
    );

    final proposal = base.toProposal(document: document);

    return proposal;
  }
}
