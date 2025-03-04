import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
  ) = ProposalServiceImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  /// Encodes the [document] to exportable format.
  ///
  /// It does not save the document anywhere on the disk,
  /// it only encodes a document as [Uint8List]
  /// so that it can be saved as a file.
  Future<Uint8List> encodeProposalForExport({
    required DocumentDataMetadata metadata,
    required Document document,
  });

  /// Fetches favorites proposals ids of the user
  Future<List<String>> getFavoritesProposalsIds();

  Future<ProposalData> getProposal({
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

  Stream<List<Proposal>> watchLatestProposals({int? limit});
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
  Future<Uint8List> encodeProposalForExport({
    required DocumentDataMetadata metadata,
    required Document document,
  }) {
    return _documentRepository.encodeDocumentForExport(
      metadata: metadata,
      document: document,
    );
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    final proposalsIds = await _proposalRepository.getFavoritesProposalsIds();
    return proposalsIds;
  }

  @override
  Future<ProposalData> getProposal({
    required String id,
  }) async {
    const proposalTemplate = DocumentSchema(
      parentSchemaUrl: '',
      schemaSelfUrl: '',
      title: '',
      description: MarkdownData.empty,
      properties: [],
      order: [],
    );
    final version = const Uuid().v7();
    return ProposalData(
      document: ProposalDocument(
        metadata: ProposalMetadata(
          id: id,
          version: version,
        ),
        document: const Document(
          schema: proposalTemplate,
          properties: [],
        ),
      ),
      categoryId: '',
      ref: SignedDocumentRef(
        id: id,
        version: version,
      ),
    );
  }

  @override
  Future<ProposalPaginationItems<Proposal>> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    final proposals = await _proposalRepository.getProposals(
      request: request,
    );

    return ProposalPaginationItems(
      items: proposals.proposals,
      pageKey: request.pageKey,
      maxResults: proposals.maxResults,
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
  Stream<List<Proposal>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchProposalsDocuments(limit: limit)
        .switchMap((documents) async* {
      final proposalsStreams = await Future.wait(
        documents.map((doc) async {
          final ref = SignedDocumentRef(
            id: doc.metadata.id,
            version: doc.metadata.version,
          );
          final versionIds =
              await _documentRepository.queryVersionIds(id: doc.metadata.id);

          return _documentRepository
              .watchCount(ref: ref, type: DocumentType.commentTemplate)
              .map((commentsCount) {
            final proposalData = ProposalData(
              document: doc,
              categoryId: DocumentType.categoryParametersDocument.uuid,
              versions: versionIds,
              commentsCount: commentsCount,
              ref: ref,
            );
            return Proposal.fromData(proposalData);
          });
        }),
      );

      await for (final commentsUpdates in Rx.combineLatest(
        proposalsStreams,
        (List<Proposal> proposals) => proposals,
      )) {
        yield commentsUpdates;
      }
    });
  }
}
