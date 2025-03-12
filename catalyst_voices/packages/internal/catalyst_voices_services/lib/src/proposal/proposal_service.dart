import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_services/src/user/user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
    SignedDocumentManager signedDocumentManager,
    UserService userService,
    KeyDerivationService keyDerivationService,
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

  Future<ProposalData> getProposal({
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
  Future<void> publishProposal({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  });

  Future<List<String>> removeFavoriteProposal(String proposalId);

  /// Submits a proposal draft into review.
  Future<void> submitProposalForReview({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  });

  /// Saves a new proposal draft in the local storage.
  Future<void> updateDraftProposal({
    required DraftRef ref,
    required DocumentDataContent content,
  });

  Stream<List<Proposal>> watchLatestProposals({int? limit});
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final SignedDocumentManager _signedDocumentManager;
  final UserService _userService;
  final KeyDerivationService _keyDerivationService;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._signedDocumentManager,
    this._userService,
    this._keyDerivationService,
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
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    final document = await _documentRepository.getProposalDocument(
      ref: ref,
    );

    return ProposalData(
      document: document,
      categoryId: const Uuid().v7(),
      commentsCount: 10,
      versions: [
        ...List.generate(3, (_) => const Uuid().v7()),
        document.metadata.selfRef.version!,
      ],
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
  Future<void> publishProposal({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  }) async {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError('Cannot publish a proposal, account missing');
    }

    final masterKey = await account.keychain.getMasterKey();
    if (masterKey == null) {
      throw StateError('Cannot publish a proposal, master key missing');
    }

    final keyPair = await _keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.proposer,
    );

    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(content.data),
      metadata: _createProposalMetadata(metadata),
      publicKey: keyPair.publicKey,
      privateKey: keyPair.privateKey,
    );

    await _documentRepository.uploadDocument(document: signedDocument);
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    return _proposalRepository.removeFavoriteProposal(proposalId);
  }

  @override
  Future<void> submitProposalForReview({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  }) async {
    // TODO(dtscalac): implement
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

  @override
  Stream<List<Proposal>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchProposalsDocuments(limit: limit)
        .switchMap((documents) async* {
      final proposalsStreams = await Future.wait(
        documents.map((doc) async {
          final versionIds = await _documentRepository.queryVersionIds(
            id: doc.metadata.selfRef.id,
          );

          return _documentRepository
              .watchCount(
            ref: doc.metadata.selfRef,
            type: DocumentType.commentTemplate,
          )
              .map((commentsCount) {
            final proposalData = ProposalData(
              document: doc,
              categoryId: DocumentType.categoryParametersDocument.uuid,
              versions: versionIds,
              commentsCount: commentsCount,
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

  SignedDocumentMetadata _createProposalMetadata(
    DocumentDataMetadata metadata,
  ) {
    final template = metadata.template;

    return SignedDocumentMetadata(
      contentType: SignedDocumentContentType.json,
      documentType: DocumentType.proposalDocument,
      id: metadata.id,
      ver: metadata.selfRef.version,
      template: template == null
          ? null
          : SignedDocumentMetadataRef.fromDocumentRef(template),
    );
  }
}
