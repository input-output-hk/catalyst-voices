import 'dart:async';

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
    SyncManager syncManager,
  ) = ProposalServiceImpl;

  Future<void> addFavoriteProposal({
    required DocumentRef id,
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
    required DocumentRef category,
  });

  /// Similar to [watchProposal] but also will synchronize any missing documents for [id].
  ///
  /// If document with [id] is not found locally it will try to synchronize and get it remotely and
  /// when such document is not found remotely null will be returned.
  ///
  /// If [id] is a [DraftRef] then [activeAccount] must be non null and author of such document,
  /// otherwise will return null, even if found.
  Future<ProposalDataV2?> getProposalV2({required DocumentRef id, CatalystId? activeAccount});

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
    required DocumentRef id,
  });

  Future<void> submitCollaboratorProposalAction({
    required SignedDocumentRef proposalId,
    required CollaboratorProposalAction action,
  });

  /// Submits a proposal draft into review.
  ///
  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> submitProposalForReview({
    required SignedDocumentRef proposalId,
  });

  /// Returns the [SignedDocumentRef] of the created [ProposalSubmissionAction].
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalId,
  });

  /// Upserts a proposal draft in the local storage.
  Future<void> upsertDraftProposal({
    required DraftRef id,
    required DocumentDataContent content,
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
  });

  Future<CollaboratorValidationResult> validateForCollaborator(CatalystId id);

  Stream<AccountInvitesApprovalsCount> watchInvitesApprovalsCount({required CatalystId id});

  /// Streams changes to [isMaxProposalsLimitReached].
  Stream<bool> watchMaxProposalsLimitReached();

  /// Stream emits [ProposalDataV2] whenever underlying database changes so it emits newest
  /// available data.
  ///
  /// Returns null if proposal with [id] is not found.
  /// Be aware if latest proposal submission action is a [ProposalSubmissionAction.hide],
  /// such document will be returned.
  ///
  /// If [id] is a [DraftRef] then such proposal will be returned only if [activeAccount]
  /// is an author.
  Stream<ProposalDataV2?> watchProposal({required DocumentRef id, CatalystId? activeAccount});

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
    bool includeLocalDrafts,
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
  final SyncManager _syncManager;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._userService,
    this._signerService,
    this._activeCampaignObserver,
    this._syncManager,
  );

  @override
  Future<void> addFavoriteProposal({required DocumentRef id}) {
    return _proposalRepository.updateProposalFavorite(id: id.id, isFavorite: true);
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
          id: draftRef,
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
    return _publishProposalAction(proposalId, ProposalSubmissionAction.hide);
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
    required DocumentRef category,
  }) async {
    final proposalTemplate = await _proposalRepository.getProposalTemplate(
      category: category,
    );

    if (proposalTemplate == null) {
      throw DocumentNotFoundException(ref: category);
    }

    return proposalTemplate;
  }

  @override
  Future<ProposalDataV2?> getProposalV2({
    required DocumentRef id,
    CatalystId? activeAccount,
  }) async {
    final isCached = id.isExact && await _documentRepository.isCached(id: id);
    if (!isCached) {
      await _syncManager.complete(TargetSyncRequest(id.toSignedDocumentRef().toLoose()));

      final metadata = await _documentRepository
          .getDocumentMetadata(id: id)
          .then<DocumentDataMetadata?>((value) => value)
          .onError<DocumentNotFoundException>((_, _) => null);

      if (metadata != null && metadata.parameters.isNotEmpty) {
        await _syncManager.complete(ParametersSyncRequest.commentTemplate(metadata.parameters));
      }
    }

    final localProposalData = activeAccount != null
        ? await _proposalRepository.getLocalProposal(id: id, originalAuthor: activeAccount)
        : null;

    final proposalData = await _proposalRepository.getProposalV2(id: id);

    return _mergePublicAndLocalProposal(id, localProposalData, proposalData);
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data) async {
    final activeCampaign = _activeCampaignObserver.campaign;
    if (activeCampaign == null) {
      throw const ActiveCampaignNotFoundException();
    }

    final parsedDocument = await _documentRepository.parseDocumentForImport(data: data);
    final template = parsedDocument.metadata.template;
    final templateParameters =
        // TODO(damian-molinski): replace with getDocumentMetadata
        await (template != null
                ? _documentRepository.getDocumentData(id: template)
                : Future<DocumentData?>.value())
            .then((value) => value?.metadata.parameters)
            .onError<DocumentNotFoundException>((_, _) => null)
            .then((value) => value ?? const DocumentParameters());

    // Validate template before any DB operations
    // TODO(LynxLynxx): Remove after we support multiple fund templates
    if (activeCampaign.categories.none((category) => templateParameters.contains(category.id))) {
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
    final originalRef = document.id;

    // There is a system requirement to publish fresh documents,
    // where version timestamp is not older than a predefined interval.
    // Because of it we're regenerating a version just before publishing.
    final freshRef = originalRef.fresh().toSignedDocumentRef();
    final freshDocument = document.copyWithId(freshRef);

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
  Future<void> removeFavoriteProposal({required DocumentRef id}) {
    return _proposalRepository.updateProposalFavorite(id: id.id, isFavorite: false);
  }

  @override
  Future<void> submitCollaboratorProposalAction({
    required SignedDocumentRef proposalId,
    required CollaboratorProposalAction action,
  }) async {
    switch (action) {
      case CollaboratorProposalAction.acceptInvitation:
        await _publishProposalAction(proposalId, ProposalSubmissionAction.draft);
      case CollaboratorProposalAction.rejectInvitation:
        await _publishProposalAction(proposalId, ProposalSubmissionAction.hide);
      case CollaboratorProposalAction.leaveProposal:
        await _leaveProposalAsCollaborator(proposalId);
      case CollaboratorProposalAction.acceptFinal:
        await _publishProposalAction(proposalId, ProposalSubmissionAction.aFinal);
      case CollaboratorProposalAction.rejectFinal:
        await _publishProposalAction(proposalId, ProposalSubmissionAction.hide);
    }
  }

  @override
  Future<SignedDocumentRef> submitProposalForReview({
    required SignedDocumentRef proposalId,
  }) async {
    if (await isMaxProposalsLimitReached()) {
      throw const ProposalLimitReachedException(
        maxLimit: ProposalDocument.maxSubmittedProposalsPerUser,
      );
    }

    return _publishProposalAction(proposalId, ProposalSubmissionAction.aFinal);
  }

  @override
  Future<SignedDocumentRef> unlockProposal({
    required SignedDocumentRef proposalId,
  }) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionId = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionId: actionId,
          proposalId: proposalId,
          action: ProposalSubmissionAction.draft,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionId;
      },
    );
  }

  @override
  Future<void> upsertDraftProposal({
    required DraftRef id,
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
          id: id,
          template: templateRef,
          parameters: parameters,
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
  Stream<AccountInvitesApprovalsCount> watchInvitesApprovalsCount({required CatalystId id}) {
    final invitationsFilters = CollaboratorInvitationsProposalsFilter(id);
    final approvalsFilters = CollaboratorProposalApprovalsFilter(id);

    final invitationsCountStream = watchProposalsCountV2(
      filters: invitationsFilters,
    );
    final approvalsCountStream = watchProposalsCountV2(
      filters: approvalsFilters,
    );

    return Rx.combineLatest2(
      invitationsCountStream,
      approvalsCountStream,
      (invitations, approvals) =>
          AccountInvitesApprovalsCount(invitesCount: invitations, approvalsCount: approvals),
    );
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
          relationships: {
            OriginalAuthor(author),
          },
          campaign: CampaignFilters.from(campaign),
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
  Stream<ProposalDataV2?> watchProposal({required DocumentRef id, CatalystId? activeAccount}) {
    final localProposalData = activeAccount != null
        ? _proposalRepository.watchLocalProposal(id: id, originalAuthor: activeAccount)
        : Stream.value(null);

    final proposalData = _proposalRepository.watchProposal(id: id);
    return Rx.combineLatest2(
      localProposalData,
      proposalData,
      (local, public) => _mergePublicAndLocalProposal(id, local, public),
    );
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
    bool includeLocalDrafts = false,
  }) {
    // Get published proposals count
    final publishedCountStream = _proposalRepository.watchProposalsCountV2(filters: filters);

    // Get local drafts count if there's an OriginalAuthor filter
    final originalAuthor = filters.relationships.whereType<OriginalAuthor>().firstOrNull;
    final localDraftsCountStream = originalAuthor != null && includeLocalDrafts
        ? _proposalRepository.watchLocalDraftProposalsCount(author: originalAuthor.id)
        : Stream.value(0);

    // Combine both counts
    return Rx.combineLatest2<int, int, int>(
      publishedCountStream,
      localDraftsCountStream,
      (publishedCount, localDraftsCount) => publishedCount + localDraftsCount,
    );
  }

  @override
  Stream<List<ProposalBriefData>> watchWorkspaceProposalsBrief({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    // Workspace only supports showing proposals for specific relationships.
    if (filters.relationships.isEmpty) {
      return Stream.value(const <ProposalBriefData>[]);
    }

    // Workspace do not support pagination
    const signedProposalsPageRequest = PageRequest(page: 0, size: 999);
    final signedProposalsStream = watchProposalsBriefPageV2(
      request: signedProposalsPageRequest,
      filters: filters,
    ).map((page) => page.items);

    final originalAuthor = filters.relationships.whereType<OriginalAuthor>().firstOrNull;
    final localDraftProposalsStream = originalAuthor != null
        ? _proposalRepository.watchLocalDraftProposalsBrief(author: originalAuthor.id)
        : Stream.value(const <ProposalBriefData>[]);

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

  Future<void> _leaveProposalAsCollaborator(SignedDocumentRef proposalId) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) => _proposalRepository.removeCollaboratorFromProposal(
        proposalId: proposalId,
        collaboratorId: catalystId,
        privateKey: privateKey,
      ),
    );
  }

  /// Returns [ProposalDataV2] with merged versions from both sources.
  ProposalDataV2? _mergePublicAndLocalProposal(
    DocumentRef id,
    ProposalDataV2? localProposal,
    ProposalDataV2? publicProposal,
  ) {
    return switch (id) {
      DraftRef() => localProposal?.addMissingVersionsFrom(publicProposal),
      SignedDocumentRef() => publicProposal?.addMissingVersionsFrom(localProposal),
    };
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

  Future<SignedDocumentRef> _publishProposalAction(
    SignedDocumentRef proposalId,
    ProposalSubmissionAction action,
  ) async {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionId = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          actionId: actionId,
          proposalId: proposalId,
          action: action,
          catalystId: catalystId,
          privateKey: privateKey,
        );

        return actionId;
      },
    );
  }
}
