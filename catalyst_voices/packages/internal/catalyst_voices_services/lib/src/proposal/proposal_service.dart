import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_services/src/user/user_service.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
    UserService userService,
    KeyDerivationService keyDerivationService,
  ) = ProposalServiceImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  /// Creates a new proposal draft locally.
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    required SignedDocumentRef categoryId,
  });

  /// Delete a draft proposal from local storage.
  ///
  /// Published proposals cannot be deleted.
  Future<void> deleteDraftProposal(DraftRef ref);

  /// Encodes the [document] to exportable format.
  ///
  /// It does not save the document anywhere on the disk,
  /// it only encodes a document as [Uint8List]
  /// so that it can be saved as a file.
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
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
  /// The local draft referenced by the [document] is removed.
  ///
  /// The [DocumentRef] is retained but it's promoted from [DraftRef]
  /// instance to [SignedDocumentRef] instance.
  Future<SignedDocumentRef> publishProposal({
    required DocumentData document,
  });

  Future<List<String>> removeFavoriteProposal(String proposalId);

  /// Submits a proposal draft into review.
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  });

  /// Upserts a proposal draft in the local storage.
  Future<void> upsertDraftProposal({
    required DraftRef selfRef,
    required DocumentDataContent content,
    required SignedDocumentRef template,
    required SignedDocumentRef categoryId,
  });

  Stream<List<Proposal>> watchLatestProposals({int? limit});
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final UserService _userService;
  final KeyDerivationService _keyDerivationService;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._userService,
    this._keyDerivationService,
  );

  @override
  Future<List<String>> addFavoriteProposal(String proposalId) async {
    return _proposalRepository.addFavoriteProposal(proposalId);
  }

  @override
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    required SignedDocumentRef categoryId,
  }) async {
    final draftRef = DraftRef.generateFirstRef();
    await _documentRepository.upsertDocumentDraft(
      document: DocumentData(
        metadata: DocumentDataMetadata(
          type: DocumentType.proposalDocument,
          selfRef: draftRef,
          template: template,
          categoryId: categoryId,
        ),
        content: content,
      ),
    );

    return draftRef;
  }

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(ref: ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  }) {
    return _documentRepository.encodeDocumentForExport(
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
    required DocumentRef ref,
  }) async {
    final proposal = await _proposalRepository.getProposal(ref: ref);
    final document = await _documentRepository.getProposalDocument(
      ref: ref,
    );

    // TODO(damian-molinski): Delete this after documents sync is ready.
    final mergedDocument = ProposalDocument(
      metadata: proposal.document.metadata,
      document: document.document,
    );

    return ProposalData(
      document: mergedDocument,
      categoryId: proposal.categoryId,
      commentsCount: 10,
      versions: proposal.versions,
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
  Future<SignedDocumentRef> publishProposal({
    required DocumentData document,
  }) async {
    await _useProposerRoleCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposal(
          document: document,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );

    final ref = document.ref;
    if (ref is DraftRef) {
      await _documentRepository.deleteDocumentDraft(ref: ref);
    }

    return ref.toSignedDocumentRef();
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    return _proposalRepository.removeFavoriteProposal(proposalId);
  }

  @override
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  }) {
    return _useProposerRoleCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposalAction(
          ref: ref,
          categoryId: categoryId,
          action: ProposalSubmissionAction.aFinal,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );
  }

  @override
  Future<void> upsertDraftProposal({
    required DraftRef selfRef,
    required DocumentDataContent content,
    required SignedDocumentRef template,
    required SignedDocumentRef categoryId,
  }) async {
    await _documentRepository.upsertDocumentDraft(
      document: DocumentData(
        metadata: DocumentDataMetadata(
          type: DocumentType.proposalDocument,
          selfRef: selfRef,
          template: template,
          categoryId: categoryId,
        ),
        content: content,
      ),
    );
  }

  @override
  Stream<List<Proposal>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchProposalsDocuments(limit: limit)
        .switchMap((documents) async* {
      final proposalsStreams = await Future.wait(
        documents.map((doc) async {
          final versionIds = await _documentRepository.queryVersionsOfId(
            id: doc.metadata.selfRef.id,
          );
          final versionsData = versionIds
              .map(
                (e) => BaseProposalData(
                  document: e,
                  categoryId: SignedDocumentRef.generateFirstRef(),
                ),
              )
              .toList();

          return _documentRepository
              .watchCount(
            ref: doc.metadata.selfRef,
            type: DocumentType.commentTemplate,
          )
              .map((commentsCount) {
            final proposalData = ProposalData(
              document: doc,
              categoryId: SignedDocumentRef(
                id: DocumentType.categoryParametersDocument.uuid,
              ),
              versions: versionsData,
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

  Future<void> _useProposerRoleCredentials(
    Future<void> Function(
      CatalystId catalystId,
      CatalystPrivateKey privateKey,
    ) callback,
  ) async {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError(
        'Cannot obtain proposer credentials, account missing',
      );
    }

    final catalystId = account.catalystId.copyWith(
      role: const Optional(AccountRole.proposer),
      rotation: const Optional(0),
    );

    await account.keychain.getMasterKey().use((masterKey) async {
      final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.proposer,
      );

      await keyPair.use(
        (keyPair) => callback(catalystId, keyPair.privateKey),
      );
    });
  }
}
