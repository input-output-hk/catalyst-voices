import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// ProposalService provides proposal-related functionality like: creating and signing proposals,
/// retrieving proposals data from local storage, which needs to be merged from different document types.
abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    DocumentRepository documentRepository,
    UserService userService,
    SignerService signerService,
    ActiveCampaignObserver activeCampaignObserver,
    CastedVotesObserver castedVotesObserver,
  ) = ProposalServiceImpl;

  Future<void> addFavoriteProposal({
    required DocumentRef ref,
  });

  /// Creates a new proposal draft locally.
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
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
    required DocumentParameters proposalParameters,
  });

  /// Similar to [watchFavoritesProposalsIds] stops after first emit.
  Future<List<String>> getFavoritesProposalsIds();

  Future<DocumentRef> getLatestProposalVersion({required DocumentRef ref});

  Future<DetailProposal> getProposal({
    required DocumentRef ref,
  });

  Future<ProposalDetailData> getProposalDetail({
    required DocumentRef ref,
  });

  Future<Page<ProposalWithContext>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef category,
  });

  /// Imports the proposal from [data] encoded by [encodeProposalForExport].
  ///
  /// The proposal reference will be altered to avoid linking
  /// the imported proposal to the old proposal.
  ///
  /// Once imported from the version management point of view this becomes
  /// a new standalone proposal not related to the previous one.
  Future<DocumentRef> importProposal(Uint8List data);

  /// Returns true if the current user has
  /// reached the limit of submitted proposals.
  Future<bool> isMaxProposalsLimitReached();

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
    required DocumentParameters proposalParameters,
  });

  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalRef,
    required DocumentParameters proposalParameters,
  });

  /// Upserts a proposal draft in the local storage.
  Future<void> upsertDraftProposal({
    required DraftRef selfRef,
    required DocumentDataContent content,
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
  });

  /// Fetches favorites proposals ids of the user
  Stream<List<String>> watchFavoritesProposalsIds();

  /// Emits when proposal fav status changes.
  Stream<bool> watchIsFavoritesProposal({
    required DocumentRef ref,
  });

  /// Streams changes to [isMaxProposalsLimitReached].
  Stream<bool> watchMaxProposalsLimitReached();

  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  });

  Stream<Page<Proposal>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  Stream<List<DetailProposal>> watchUserProposals();

  Stream<ProposalsCount> watchUserProposalsCount();
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final UserService _userService;
  final SignerService _signerService;
  final ActiveCampaignObserver _activeCampaignObserver;
  final CastedVotesObserver _castedVotesObserver;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._userService,
    this._signerService,
    this._activeCampaignObserver,
    this._castedVotesObserver,
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
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
  }) async {
    final draftRef = DraftRef.generateFirstRef();
    final catalystId = _userService.activeAccountId;

    await _proposalRepository.upsertDraftProposal(
      document: DocumentData(
        metadata: DocumentDataMetadata.proposal(
          selfRef: draftRef,
          template: templateRef,
          parameters: parameters,
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
    required DocumentParameters proposalParameters,
  }) {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          metadata: DocumentDataMetadata.proposalAction(
            selfRef: actionRef,
            proposalRef: proposalRef,
            parameters: proposalParameters,
          ),
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
  Future<DocumentRef> getLatestProposalVersion({
    required DocumentRef ref,
  }) async {
    final proposalVersions = await _documentRepository.getAllVersionsOfId(
      id: ref.id,
    );
    final refList = List<DocumentRef>.from(
      proposalVersions.map((e) => e.metadata.selfRef).toList(),
    )..sort();

    return refList.last;
  }

  @override
  Future<DetailProposal> getProposal({
    required DocumentRef ref,
  }) async {
    final proposalData = await _proposalRepository.getProposal(ref: ref);
    final versions = await _getDetailVersionsOfProposal(proposalData);

    return DetailProposal.fromData(proposalData, versions);
  }

  @override
  Future<ProposalDetailData> getProposalDetail({required DocumentRef ref}) async {
    final proposalData = await _proposalRepository.getProposal(ref: ref);
    final version = await _getDetailVersionsOfProposal(proposalData);

    return ProposalDetailData(
      document: proposalData.document,
      publish: proposalData.publish,
      commentsCount: proposalData.commentsCount,
      versions: version,
    );
  }

  @override
  Future<Page<ProposalWithContext>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) async {
    // TODO(LynxxLynx): Only for mocking! Remove this when we start supporting writing votes to the database
    final originalFilters = filters;
    if (filters.type == ProposalsFilterType.voted) {
      filters = filters.copyWith(type: ProposalsFilterType.total);
    }

    final proposalsPage = await _proposalRepository
        .getProposalsPage(request: request, filters: filters, order: order)
        .then(_mapProposalDataPage);
    var proposals = proposalsPage.items;

    // TODO(LynxxLynx): Only for mocking! Remove this when we start supporting writing votes to the database
    if (originalFilters.type == ProposalsFilterType.voted) {
      final votedProposals = _castedVotesObserver.votes;
      final votedProposalIds = votedProposals.map((vote) => vote.proposal).toSet();
      proposals = proposals
          .where((proposal) => votedProposalIds.contains(proposal.selfRef))
          .toList();
    }

    // If we are getting proposals then campaign needs to be active
    // Getting whole campaign with list of categories saves time then calling to get each category separately
    // for each proposal
    final proposalsWithContext = proposals
        .map(
          (proposal) => ProposalWithContext(
            proposal: proposal,
            category: _findActiveCampaignCategory(proposal.parameters),
            user: const ProposalUserContext(),
          ),
        )
        .toList();

    return proposalsPage.copyWithItems(proposalsWithContext);
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef category,
  }) async {
    final template = await _proposalRepository.getProposalTemplate(category: category);
    if (template == null) {
      throw ProposalTemplateNotFoundException(category: category);
    }

    return template;
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data) async {
    final activeCampaign = _activeCampaignObserver.campaign;
    if (activeCampaign == null) {
      throw const ActiveCampaignNotFoundException();
    }

    final campaignFilters = CampaignFilters.from(activeCampaign);
    final allowTemplateRefs = await _documentRepository.getRefs(
      type: DocumentType.proposalTemplate,
      campaign: campaignFilters,
    );

    final parsedDocument = await _documentRepository.parseDocumentForImport(data: data);

    // Validate template before any DB operations
    // TODO(LynxLynxx): Remove after we support multiple fund templates
    if (!allowTemplateRefs.contains(parsedDocument.metadata.template)) {
      throw const DocumentImportInvalidDataException(
        DocumentMetadataMalformedException(
          reasons: ['template ref is not allowed to be imported'],
        ),
      );
    }

    final authorId = _userService.activeAccountId;
    final newRef = await _documentRepository.saveImportedDocument(
      document: parsedDocument,
      authorId: authorId,
    );

    return newRef;
  }

  @override
  Future<bool> isMaxProposalsLimitReached() async {
    // By default return true to prevent creating proposals
    // if we couldn't determine the state due to an error.
    return watchMaxProposalsLimitReached().first.catchError((_) => true);
  }

  @override
  Future<SignedDocumentRef> publishProposal({
    required DocumentData document,
  }) async {
    final originalRef = document.ref;

    // There is a system requirement to publish fresh documents,
    // where version timestamp is not older than a predefined interval.
    // Because of it we're regenerating a version just before publishing.
    final freshRef = originalRef.fresh().toSignedDocumentRef();
    final freshDocument = document.copyWithSelfRef(selfRef: freshRef);

    await _signerService.useProposerCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposal(
          document: freshDocument,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );

    if (originalRef is DraftRef) {
      await _proposalRepository.deleteDraftProposal(originalRef);
    }

    return freshRef;
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
    required DocumentParameters proposalParameters,
  }) async {
    if (await isMaxProposalsLimitReached()) {
      throw const ProposalLimitReachedException(
        maxLimit: ProposalDocument.maxSubmittedProposalsPerUser,
      );
    }

    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          metadata: DocumentDataMetadata.proposalAction(
            selfRef: actionRef,
            proposalRef: proposalRef,
            parameters: proposalParameters,
          ),
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
    required DocumentParameters proposalParameters,
  }) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          metadata: DocumentDataMetadata.proposalAction(
            selfRef: actionRef,
            proposalRef: proposalRef,
            parameters: proposalParameters,
          ),
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
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
  }) async {
    // TODO(LynxLynxx): when we start supporting multiple authors
    // we need to get the list of authors actually stored in the db and
    // add them to the authors list if they are not already there
    final catalystId = _userService.activeAccountId;

    await _proposalRepository.upsertDraftProposal(
      document: DocumentData(
        metadata: DocumentDataMetadata.proposal(
          selfRef: selfRef,
          template: templateRef,
          parameters: parameters,
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
  Stream<bool> watchMaxProposalsLimitReached() {
    return watchUserProposalsCount().map((count) {
      return count.finals >= ProposalDocument.maxSubmittedProposalsPerUser;
    });
  }

  @override
  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    final proposalsCount = _proposalRepository.watchProposalsCount(filters: filters);

    // TODO(LynxxLynx): Remove this when we start supporting writing votes to the database
    return proposalsCount.switchMap((count) {
      return _castedVotesObserver.watchCastedVotes.map((votedProposals) {
        return count.copyWith(
          voted: votedProposals.length,
        );
      });
    });
  }

  @override
  Stream<Page<Proposal>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _proposalRepository
        .watchProposalsPage(request: request, filters: filters, order: order)
        .asyncMap(_mapProposalDataPage);
  }

  @override
  Stream<List<DetailProposal>> watchUserProposals() async* {
    yield* _userService //
        .watchUser
        .distinct()
        .switchMap(_userWhenUnlockedStream)
        .switchMap((user) {
          if (user == null) return const Stream.empty();

          final authorId = user.activeAccount?.catalystId;
          if (!_isProposer(user) || authorId == null) {
            return const Stream.empty();
          }

          return _proposalRepository
              .watchUserProposals(authorId: authorId)
              .distinct()
              .switchMap<List<DetailProposal>>((documents) async* {
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
                    // Note. one is null and two versions of same id.
                    final validProposalsData = proposalsData.whereType<ProposalData>().toList();

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
                      filteredProposalsData.map((proposalData) async {
                        final versions = await _getDetailVersionsOfProposal(proposalData);
                        return DetailProposal.fromData(proposalData, versions);
                      }),
                    );
                    return proposalsWithVersions;
                  },
                ).switchMap(Stream.fromFuture);
              });
        });
  }

  @override
  Stream<ProposalsCount> watchUserProposalsCount() {
    return _userService //
        .watchUser
        .distinct()
        .switchMap(_userWhenUnlockedStream)
        .switchMap((user) {
          if (user == null) return const Stream.empty();

          final authorId = user.activeAccount?.catalystId;
          if (!_isProposer(user) || authorId == null) {
            // user is not eligible for creating proposals
            return const Stream.empty();
          }

          final activeCampaign = _activeCampaignObserver.campaign;
          final categoriesIds = activeCampaign?.categories.map((e) => e.selfRef.id).toList();

          final filters = ProposalsCountFilters(
            author: authorId,
            onlyAuthor: true,
            campaign: categoriesIds != null ? CampaignFilters(categoriesIds: categoriesIds) : null,
          );

          return watchProposalsCount(filters: filters);
        });
  }

  Future<Stream<ProposalData?>> _createProposalDataStream(
    ProposalDocument doc,
  ) async {
    final selfRef = doc.metadata.selfRef;

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
          publish: publishState,
          commentsCount: commentsCount,
        );
      },
    );
  }

  CampaignCategory _findActiveCampaignCategory(DocumentParameters parameters) {
    final activeCampaign = _activeCampaignObserver.campaign;
    return activeCampaign!.categories.firstWhere(
      (category) => parameters.contains(category.selfRef),
    );
  }

  // Helper method to fetch versions for a proposal
  Future<List<ProposalVersion>> _getDetailVersionsOfProposal(ProposalData proposal) async {
    final versions = await _proposalRepository.queryVersionsOfId(
      id: proposal.document.metadata.selfRef.id,
      includeLocalDrafts: true,
    );
    final versionsData = (await Future.wait(
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
    )).whereType<ProposalData>().toList();

    return versionsData.map((e) => e.toProposalVersion()).toList();
  }

  bool _isProposer(User user) {
    return user.activeAccount?.roles.contains(AccountRole.proposer) ?? false;
  }

  Future<Page<Proposal>> _mapProposalDataPage(Page<ProposalData> page) async {
    final proposals = await page.items.map(
      (item) async {
        final versions = await _proposalRepository
            .queryVersionsOfId(
              id: item.document.metadata.selfRef.id,
              includeLocalDrafts: true,
            )
            .then(
              (value) => value.map((e) => e.metadata.selfRef.version!).whereType<String>().toList(),
            );

        return Proposal.fromData(item, versions);
      },
    ).wait;

    return page.copyWithItems(proposals);
  }

  Stream<User?> _userWhenUnlockedStream(User user) {
    final activeAccount = user.activeAccount;

    if (activeAccount == null) return Stream.value(null);

    final isUnlockedStream = activeAccount.keychain.watchIsUnlocked;
    return isUnlockedStream.map((isUnlocked) => isUnlocked ? user : null);
  }
}
