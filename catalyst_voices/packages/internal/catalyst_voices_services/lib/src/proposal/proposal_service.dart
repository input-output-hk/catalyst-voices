import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
    UserService userService,
    SignerService signerService,
    CampaignRepository campaignRepository,
  ) = ProposalServiceImpl;

  Future<void> addFavoriteProposal({
    required DocumentRef ref,
  });

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

  Future<void> forgetProposal({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  });

  /// Similar to [watchFavoritesProposalsIds] stops after first emit.
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

  Future<void> removeFavoriteProposal({
    required DocumentRef ref,
  });

  /// Submits a proposal draft into review.
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  });

  Future<void> unlockProposal({
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

  /// Fetches favorites proposals ids of the user
  Stream<List<String>> watchFavoritesProposalsIds();

  /// Emits when proposal fav status changes.
  Stream<bool> watchIsFavoritesProposal({
    required DocumentRef ref,
  });

  Stream<List<Proposal>> watchLatestProposals({int? limit});

  Stream<List<Proposal>> watchUserProposals();
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final UserService _userService;
  final SignerService _signerService;
  final CampaignRepository _campaignRepository;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._userService,
    this._signerService,
    this._campaignRepository,
  );

  @override
  Future<void> addFavoriteProposal({required DocumentRef ref}) {
    return _documentRepository.updateDocumentFavorite(
      ref: ref.toLoose(),
      type: DocumentType.proposalDocument,
      isFavorite: true,
    );
  }

  @override
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    required SignedDocumentRef categoryId,
  }) async {
    final draftRef = DraftRef.generateFirstRef();
    final catalystId = await _getUserCatalystId();
    await _proposalRepository.upsertDraftProposal(
      document: DocumentData(
        metadata: DocumentDataMetadata(
          type: DocumentType.proposalDocument,
          selfRef: draftRef,
          template: template,
          categoryId: categoryId,
          authors: [catalystId],
        ),
        content: content,
      ),
    );

    return draftRef;
  }

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _proposalRepository.deleteDraftProposal(ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  }) {
    return _proposalRepository.encodeProposalForExport(
      document: document,
    );
  }

  @override
  Future<void> forgetProposal({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  }) {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposalAction(
          ref: ref,
          categoryId: categoryId,
          action: ProposalSubmissionAction.hide,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() {
    return _documentRepository
        .watchAllDocumentsFavoriteIds(type: DocumentType.proposalDocument)
        .first;
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    return _proposalRepository.getProposal(ref: ref);
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
    final proposalTemplate = await _proposalRepository.getProposalTemplate(
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
  Future<DocumentRef> importProposal(Uint8List data) async {
    final authorId = await _getUserCatalystId();
    return _proposalRepository.importProposal(data, authorId);
  }

  @override
  Future<SignedDocumentRef> publishProposal({
    required DocumentData document,
  }) async {
    await _signerService.useProposerCredentials(
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
      await _proposalRepository.deleteDraftProposal(ref);
    }

    return ref.toSignedDocumentRef();
  }

  @override
  Future<void> removeFavoriteProposal({required DocumentRef ref}) {
    return _documentRepository.updateDocumentFavorite(
      ref: ref.toLoose(),
      type: DocumentType.proposalDocument,
      isFavorite: false,
    );
  }

  @override
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  }) {
    return _signerService.useProposerCredentials(
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
  Future<void> unlockProposal({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  }) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposalAction(
          ref: ref,
          categoryId: categoryId,
          action: ProposalSubmissionAction.draft,
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
    // TODO(LynxLynxx): when we start supporting multiple authors
    // we need to get the list of authors actually stored in the db and
    // add them to the authors list if they are not already there
    final catalystId = await _getUserCatalystId();

    await _proposalRepository.upsertDraftProposal(
      document: DocumentData(
        metadata: DocumentDataMetadata(
          type: DocumentType.proposalDocument,
          selfRef: selfRef,
          template: template,
          categoryId: categoryId,
          authors: [catalystId],
        ),
        content: content,
      ),
    );
  }

  @override
  Stream<List<String>> watchFavoritesProposalsIds() {
    return _documentRepository.watchAllDocumentsFavoriteIds(
      type: DocumentType.proposalDocument,
    );
  }

  @override
  Stream<bool> watchIsFavoritesProposal({required DocumentRef ref}) {
    return _documentRepository.watchIsDocumentFavorite(ref: ref.toLoose());
  }

  @override
  Stream<List<Proposal>> watchLatestProposals({int? limit}) {
    return _proposalRepository
        .watchLatestProposals(limit: limit)
        .switchMap((documents) async* {
      final proposalsStreams = await Future.wait(
        documents.map((doc) async {
          final versionIds = await _proposalRepository.queryVersionsOfId(
            id: doc.metadata.selfRef.id,
          );
          final category =
              await _campaignRepository.getCategory(doc.metadata.categoryId);
          final versionsData = versionIds
              .map(
                (e) => BaseProposalData(document: e),
              )
              .toList();

          return _proposalRepository
              .watchCount(
            ref: doc.metadata.selfRef,
            type: DocumentType.commentTemplate,
          )
              .map((commentsCount) {
            final proposalData = ProposalData(
              document: doc,
              categoryName: category.categoryText,
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

  @override
  Stream<List<Proposal>> watchUserProposals() async* {
    final authorId = await _getUserCatalystId();
    yield* _proposalRepository
        .watchUserProposals(
      authorId: authorId,
    )
        .switchMap((documents) async* {
      final proposals = documents.map((e) async {
        final campaign =
            await _campaignRepository.getCategory(e.metadata.categoryId);
        final proposalData = ProposalData(
          document: e,
          categoryName: campaign.categoryText,
        );
        return Proposal.fromData(proposalData);
      }).toList();
      yield await Future.wait(proposals);
    });
  }

  Future<CatalystId> _getUserCatalystId() async {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError(
        'Cannot obtain proposer credentials, account missing',
      );
    }

    return account.catalystId;
  }
}
