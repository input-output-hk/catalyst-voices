import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:collection/collection.dart';
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

  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<void> forgetProposal({
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
  });

  /// Similar to [watchFavoritesProposalsIds] stops after first emit.
  Future<List<String>> getFavoritesProposalsIds();

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  Future<Page<Proposal>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

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
  ///
  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> submitProposalForReview({
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
  });

  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalRef,
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

  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  });

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
    final catalystId = _getUserCatalystId();
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
  Future<SignedDocumentRef> forgetProposal({
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
  }) {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionRef: actionRef,
          proposalRef: proposalRef,
          categoryId: categoryId,
          action: ProposalSubmissionAction.hide,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionRef;
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
  Future<Page<Proposal>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  }) {
    return _proposalRepository
        .getProposalsPage(request: request, filters: filters)
        .then((value) => value.map(Proposal.fromData));
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
  Future<DocumentRef> importProposal(Uint8List data) async {
    final authorId = _getUserCatalystId();
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
  Future<SignedDocumentRef> submitProposalForReview({
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
  }) {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionRef: actionRef,
          proposalRef: proposalRef,
          categoryId: categoryId,
          action: ProposalSubmissionAction.aFinal,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionRef;
      },
    );
  }

  @override
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
  }) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionRef: actionRef,
          proposalRef: proposalRef,
          categoryId: categoryId,
          action: ProposalSubmissionAction.draft,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionRef;
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
    final catalystId = _getUserCatalystId();

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
      final proposalsDataStreams = await Future.wait(
        documents.map(_createProposalDataStream).toList(),
      );

      yield* Rx.combineLatest(
        proposalsDataStreams,
        (List<ProposalData?> proposalsData) async {
          final validProposalsData =
              proposalsData.whereType<ProposalData>().toList();
          final proposalsWithVersions = await Future.wait(
            validProposalsData.map(_addVersionsToProposal),
          );
          return proposalsWithVersions.map(Proposal.fromData).toList();
        },
      ).switchMap(Stream.fromFuture);
    });
  }

  @override
  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    return _proposalRepository.watchProposalsCount(filters: filters);
  }

  @override
  Stream<List<Proposal>> watchUserProposals() async* {
    yield* _userService.watchUser.distinct().switchMap((user) {
      final authorId = user.activeAccount?.catalystId;
      if (!_isProposer(user) || authorId == null) {
        return const Stream.empty();
      }

      return _proposalRepository
          .watchUserProposals(authorId: authorId)
          .distinct()
          .switchMap((documents) async* {
        if (documents.isEmpty) {
          yield [];
          return;
        }
        final proposalsDataStreams = await Future.wait(
          documents.map(_createProposalDataStream).toList(),
        );

        yield* Rx.combineLatest(
          proposalsDataStreams,
          (List<ProposalData?> proposalsData) async {
            final validProposalsData =
                proposalsData.whereType<ProposalData>().toList();

            final groupedProposals = groupBy(
              validProposalsData,
              (data) => data.document.metadata.selfRef.id,
            );

            final filteredProposalsData = groupedProposals.values
                .map((group) {
                  if (group.any(
                    (p) => p.publish != ProposalPublish.localDraft,
                  )) {
                    return group.where(
                      (p) => p.publish != ProposalPublish.localDraft,
                    );
                  }
                  return group;
                })
                .expand((group) => group)
                .toList();

            final proposalsWithVersions = await Future.wait(
              filteredProposalsData.map(_addVersionsToProposal),
            );
            return proposalsWithVersions.map(Proposal.fromData).toList();
          },
        ).switchMap(Stream.fromFuture);
      });
    });
  }

  // Helper method to fetch versions for a proposal
  Future<ProposalData> _addVersionsToProposal(ProposalData proposal) async {
    final versions = await _proposalRepository.queryVersionsOfId(
      id: proposal.document.metadata.selfRef.id,
      includeLocalDrafts: true,
    );
    final proposalDataVersion = (await Future.wait(
      versions.map(
        (e) async {
          final selfRef = e.metadata.selfRef;
          final action = await _proposalRepository.getProposalPublishForRef(
            ref: selfRef,
          );
          if (action == null) {
            return null;
          }

          return ProposalData(
            document: e,
            publish: action,
          );
        },
      ).toList(),
    ))
        .whereType<ProposalData>()
        .toList();

    return proposal.copyWith(versions: proposalDataVersion);
  }

  Future<Stream<ProposalData?>> _createProposalDataStream(
    ProposalDocument doc,
  ) async {
    final selfRef = doc.metadata.selfRef;
    final campaign =
        await _campaignRepository.getCategory(doc.metadata.categoryId);

    final commentsCountStream = _proposalRepository.watchCommentsCount(
      refTo: selfRef,
    );

    return Rx.combineLatest2(
      _proposalRepository.watchProposalPublish(refTo: selfRef),
      commentsCountStream,
      (ProposalPublish? publishState, int commentsCount) {
        if (publishState == null) return null;

        return ProposalData(
          document: doc,
          categoryName: campaign.categoryText,
          publish: publishState,
          commentsCount: commentsCount,
        );
      },
    );
  }

  CatalystId _getUserCatalystId() {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError(
        'Cannot obtain proposer credentials, account missing',
      );
    }

    return account.catalystId;
  }

  bool _isProposer(User user) {
    return user.activeAccount?.roles.contains(AccountRole.proposer) ?? false;
  }
}
