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
  ) = ProposalServiceImpl;

  Future<void> addFavoriteProposal({
    required DocumentRef id,
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
  Future<void> deleteDraftProposal(DraftRef id);

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
    required SignedDocumentRef proposalId,
  });

  Future<DocumentRef> getLatestProposalVersion({required DocumentRef id});

  Future<DetailProposal> getProposal({
    required DocumentRef id,
  });

  Future<ProposalDetailData> getProposalDetail({
    required DocumentRef id,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef id,
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

  Future<void> respondToCollaboratorInvite({
    required DocumentRef ref,
    required CollaboratorInvitationAction action,
  });

  /// Submits a proposal draft into review.
  ///
  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> submitProposalForReview({
    required SignedDocumentRef proposalId,
    required SignedDocumentRef categoryId,
  });

  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalId,
  });

  /// Upserts a proposal draft in the local storage.
  Future<void> upsertDraftProposal({
    required DraftRef id,
    required DocumentDataContent content,
    required SignedDocumentRef template,
    required SignedDocumentRef categoryId,
  });

  Future<CollaboratorValidationResult> validateForCollaborator(CatalystId id);

  /// Streams changes to [isMaxProposalsLimitReached].
  Stream<bool> watchMaxProposalsLimitReached();

  Stream<ProposalDataV2?> watchProposal({required DocumentRef id});

  /// Streams pages of brief proposal data.
  ///
  /// The [request] parameter defines the page number and size.
  /// The optional [order] parameter specifies how the results should be sorted.
  /// The optional [filters] parameter can be used to filter proposals based on various criteria.
  /// Returns a stream of [Page] with [ProposalBriefData] that updates as the
  /// underlying data changes.
  Stream<Page<ProposalBriefData>> watchProposalsBriefPageV2({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters,
  });

  /// Similar to [watchProposalsBriefPageV2] but also includes local drafts of proposals
  /// but do not support pagination.
  Stream<List<ProposalBriefData>> watchWorkspaceProposalsBrief({
    ProposalsFiltersV2 filters,
  });
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final UserService _userService;
  final SignerService _signerService;
  final ActiveCampaignObserver _activeCampaignObserver;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._userService,
    this._signerService,
    this._activeCampaignObserver,
  );

  @override
  Future<void> addFavoriteProposal({required DocumentRef id}) {
    return _proposalRepository.updateProposalFavorite(id: id.id, isFavorite: true);
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
        metadata: DocumentDataMetadata.proposal(
          id: draftRef,
          template: template,
          parameters: DocumentParameters({categoryId}),
          authors: [catalystId],
        ),
        content: content,
      ),
    );

    return draftRef;
  }

  @override
  Future<void> deleteDraftProposal(DraftRef id) {
    return _proposalRepository.deleteDraftProposal(id);
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
    required SignedDocumentRef proposalId,
  }) {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionId = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionId: actionId,
          proposalId: proposalId,
          action: ProposalSubmissionAction.hide,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionId;
      },
    );
  }

  @override
  Future<DocumentRef> getLatestProposalVersion({required DocumentRef id}) async {
    final latest = await _documentRepository.getLatestOf(id: id);
    if (latest == null) {
      throw DocumentNotFoundException(ref: id);
    }

    return latest;
  }

  @override
  Future<DetailProposal> getProposal({
    required DocumentRef id,
  }) async {
    final proposalData = await _proposalRepository.getProposal(ref: id);
    final versions = await _getDetailVersionsOfProposal(proposalData);

    return DetailProposal.fromData(proposalData, versions);
  }

  @override
  Future<ProposalDetailData> getProposalDetail({required DocumentRef id}) async {
    final proposalData = await _proposalRepository.getProposal(ref: id);
    final version = await _getDetailVersionsOfProposal(proposalData);

    return ProposalDetailData(
      document: proposalData.document,
      publish: proposalData.publish,
      commentsCount: proposalData.commentsCount,
      versions: version,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef id,
  }) async {
    final proposalTemplate = await _proposalRepository.getProposalTemplate(
      ref: id,
    );

    return proposalTemplate;
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data) async {
    final allowTemplateRefs =
        _activeCampaignObserver.campaign?.categories.map((e) => e.proposalTemplateRef).toList() ??
        [];

    final parsedDocument = await _documentRepository.parseDocumentForImport(data: data);

    // Validate template before any DB operations
    // TODO(LynxLynxx): Remove after we support multiple fund templates
    if (!allowTemplateRefs.contains(parsedDocument.metadata.template)) {
      throw const DocumentImportInvalidDataException(
        SignedDocumentMetadataMalformed(reasons: ['template ref is not allowed to be imported']),
      );
    }

    final authorId = _getUserCatalystId();
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
    final originalRef = document.id;

    // There is a system requirement to publish fresh documents,
    // where version timestamp is not older than a predefined interval.
    // Because of it we're regenerating a version just before publishing.
    final freshRef = originalRef.freshVersion();
    final freshDocument = document.copyWith(id: freshRef);

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

    return freshRef.toSignedDocumentRef();
  }

  @override
  Future<void> removeFavoriteProposal({required DocumentRef ref}) {
    return _proposalRepository.updateProposalFavorite(id: ref.id, isFavorite: false);
  }

  @override
  Future<void> respondToCollaboratorInvite({
    required DocumentRef ref,
    required CollaboratorInvitationAction action,
  }) async {
    // TODO(dt-iohk): replace by real implementation once data sources are ready
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  @override
  Future<SignedDocumentRef> submitProposalForReview({
    required SignedDocumentRef proposalId,
    required SignedDocumentRef categoryId,
  }) async {
    if (await isMaxProposalsLimitReached()) {
      throw const ProposalLimitReachedException(
        maxLimit: ProposalDocument.maxSubmittedProposalsPerUser,
      );
    }

    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionId = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionId: actionId,
          proposalId: proposalId,
          action: ProposalSubmissionAction.aFinal,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionId;
      },
    );
  }

  @override
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalId,
  }) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionId: actionRef,
          proposalId: proposalId,
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
    required DraftRef id,
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
        metadata: DocumentDataMetadata.proposal(
          id: id,
          template: template,
          parameters: DocumentParameters({categoryId}),
          authors: [catalystId],
        ),
        content: content,
      ),
    );
  }

  @override
  Future<CollaboratorValidationResult> validateForCollaborator(CatalystId catalystId) async {
    final (isProposer, isVerified) = await (
      _userService.validateCatalystIdForProposerRole(catalystId: catalystId),
      _userService.isPubliclyVerified(catalystId: catalystId),
    ).wait;

    return switch ((isProposer, isVerified)) {
      (true, true) => const ValidCollaborator(),
      (true, false) => const NotVerifiedProfile(),
      (false, true) => const MissingProposerRole(),
      (false, false) => const NotProposerAndNotVerified(),
    };
  }

  @override
  Stream<bool> watchMaxProposalsLimitReached() {
    final activeAccountId = _userService.watchUnlockedActiveAccount
        .map((account) => account?.catalystId)
        .distinct();
    final activeCampaign = _activeCampaignObserver.watchCampaign.distinct();

    return Rx.combineLatest2<CatalystId?, Campaign?, ProposalsFiltersV2?>(
      activeAccountId,
      activeCampaign,
      (author, campaign) {
        if (author == null || campaign == null) {
          return null;
        }

        return ProposalsFiltersV2(
          status: ProposalStatusFilter.aFinal,
          originalAuthor: author,
          campaign: ProposalsCampaignFilters.from(campaign),
        );
      },
    ).distinct().switchMap(
      (filters) {
        if (filters == null) {
          return Stream.value(true);
        }

        return _proposalRepository
            .watchProposalsCountV2(filters: filters)
            .map((event) => event >= ProposalDocument.maxSubmittedProposalsPerUser);
      },
    );
  }

  @override
  Stream<ProposalDataV2?> watchProposal({required DocumentRef id}) {
    return _proposalRepository.watchProposal(id: id);
  }

  @override
  Stream<Page<ProposalBriefData>> watchProposalsBriefPageV2({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    return _proposalRepository.watchProposalsBriefPage(
      request: request,
      order: order,
      filters: filters,
    );
  }

  @override
  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    return _proposalRepository.watchProposalsCountV2(filters: filters);
  }

  @override
  Stream<List<ProposalBriefData>> watchWorkspaceProposalsBrief({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    // Workspace only supports showing proposals for specific user.
    final originalAuthor = filters.originalAuthor;
    if (originalAuthor == null) {
      return Stream.value(const <ProposalBriefData>[]);
    }

    // Workspace do not support pagination
    const signedProposalsPageRequest = PageRequest(page: 0, size: 999);
    final signedProposalsStream = watchProposalsBriefPageV2(
      request: signedProposalsPageRequest,
      filters: filters,
    ).map((page) => page.items);

    final localDraftProposalsStream = _proposalRepository.watchLocalDraftProposalsBrief(
      author: originalAuthor,
    );

    return Rx.combineLatest2(
      signedProposalsStream,
      localDraftProposalsStream,
      _mergePublishedAndLocalProposals,
    );
  }

  // Helper method to fetch versions for a proposal
  Future<List<ProposalVersion>> _getDetailVersionsOfProposal(ProposalData proposal) async {
    final versions = await _proposalRepository.queryVersionsOfId(
      id: proposal.document.metadata.id.id,
      includeLocalDrafts: true,
    );
    final versionsData = (await Future.wait(
      versions.map(
        (e) async {
          final proposalId = e.metadata.id;
          final action = await _proposalRepository.getProposalPublishForRef(ref: proposalId);
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

  CatalystId _getUserCatalystId() {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError(
        'Cannot obtain proposer credentials, account missing',
      );
    }

    return account.catalystId;
  }

  List<ProposalBriefData> _mergePublishedAndLocalProposals(
    List<ProposalBriefData> signed,
    List<ProposalBriefData> localDrafts,
  ) {
    final documents = <String, ProposalBriefData>{
      for (final doc in signed) doc.id.id: doc,
    };

    for (final localDraft in localDrafts) {
      documents.update(
        localDraft.id.id,
        // if local draft has signed version, keep signed as main and append local draft as version
        (value) => value.appendVersion(ref: localDraft.id, title: localDraft.title),
        // if there is no signed version, add new entry
        ifAbsent: () => localDraft,
      );
    }

    return documents.values.sorted((a, b) => a.compareTo(b) * -1);
  }
}
