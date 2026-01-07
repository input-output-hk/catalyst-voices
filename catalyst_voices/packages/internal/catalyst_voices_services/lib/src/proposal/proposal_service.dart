import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
    VotingBallotBuilder ballotBuilder,
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
    required SignedDocumentRef proposalRef,
    required DocumentParameters proposalParameters,
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
    required DraftRef id,
    required DocumentDataContent content,
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
  });

  /// Streams changes to [isMaxProposalsLimitReached].
  Stream<bool> watchMaxProposalsLimitReached();

  Stream<Page<ProposalBriefData>> watchProposalsBriefPageV2({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters,
  });

  Stream<List<DetailProposal>> watchUserProposals();
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final UserService _userService;
  final SignerService _signerService;
  final ActiveCampaignObserver _activeCampaignObserver;
  final CastedVotesObserver _castedVotesObserver;
  final VotingBallotBuilder _ballotBuilder;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._documentRepository,
    this._userService,
    this._signerService,
    this._activeCampaignObserver,
    this._castedVotesObserver,
    this._ballotBuilder,
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
    required SignedDocumentRef proposalRef,
    required DocumentParameters proposalParameters,
  }) {
    return _signerService.useProposerCredentials(
      (catalystId, privateKey) async {
        final actionRef = SignedDocumentRef.generateFirstRef();

        await _proposalRepository.publishProposalAction(
          metadata: DocumentDataMetadata.proposalAction(
            id: actionRef,
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
  Future<DocumentRef> importProposal(Uint8List data) async {
    final activeCampaign = _activeCampaignObserver.campaign;
    if (activeCampaign == null) {
      throw const ActiveCampaignNotFoundException();
    }

    final campaignFilters = CampaignFilters.from(activeCampaign);
    // TODO(damian-molinski): Implement it
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
  Future<void> removeFavoriteProposal({required DocumentRef ref}) {
    return _proposalRepository.updateProposalFavorite(id: ref.id, isFavorite: false);
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
            id: actionRef,
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
            id: actionRef,
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
  Stream<Page<ProposalBriefData>> watchProposalsBriefPageV2({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    final proposals = _adaptFilters(filters).switchMap(
      (effectiveFilters) {
        return _proposalRepository.watchProposalsBriefPage(
          request: request,
          order: order,
          filters: effectiveFilters,
        );
      },
    );

    final draftVotes = _ballotBuilder.watchVotes;
    final castedVotes = _castedVotesObserver.watchCastedVotes;

    return Rx.combineLatest3(
      proposals,
      draftVotes,
      castedVotes,
      (page, draftVotes, castedVotes) {
        return page.map(
          (proposal) => _mapJoinedProposalBriefData(proposal, draftVotes, castedVotes),
        );
      },
    );
  }

  @override
  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    return _adaptFilters(filters).switchMap(
      (effectiveFilters) {
        return _proposalRepository.watchProposalsCountV2(filters: effectiveFilters);
      },
    );
  }

  @override
  Stream<List<DetailProposal>> watchUserProposals() {
    return _userService.watchUnlockedActiveAccount.distinct().switchMap((account) {
      if (account == null) return const Stream.empty();

      final authorId = account.catalystId;
      if (!account.hasRole(AccountRole.proposer)) {
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
                  (data) => data.document.metadata.id.id,
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

  // TODO(damian-molinski): Remove this when voteBy is implemented.
  Stream<ProposalsFiltersV2> _adaptFilters(ProposalsFiltersV2 filters) {
    if (filters.voteBy == null) {
      return Stream.value(filters);
    }

    return _castedVotesObserver.watchCastedVotes
        .map((votes) => votes.map((e) => e.proposal.id).toList())
        .map((ids) => filters.copyWith(voteBy: const Optional.empty(), ids: Optional(ids)));
  }

  Future<Stream<ProposalData?>> _createProposalDataStream(
    ProposalDocument doc,
  ) async {
    final proposalId = doc.metadata.id;

    final commentsCountStream = _proposalRepository.watchCommentsCount(referencing: proposalId);

    return Rx.combineLatest2(
      _proposalRepository.watchProposalPublish(referencing: proposalId),
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

  ProposalBriefData _mapJoinedProposalBriefData(
    JoinedProposalBriefData data,
    List<Vote> draftVotes,
    List<Vote> castedVotes,
  ) {
    final proposal = data.proposal;
    final isFinal = data.isFinal;

    final draftVote = isFinal
        ? draftVotes.firstWhereOrNull((vote) => vote.proposal == proposal.id)
        : null;
    final castedVote = isFinal
        ? castedVotes.firstWhereOrNull((vote) => vote.proposal == proposal.id)
        : null;

    return ProposalBriefData(
      id: proposal.id,
      authorName: data.originalAuthors.firstOrNull?.username ?? '',
      title: proposal.title ?? '',
      description: proposal.description ?? '',
      categoryName: proposal.categoryName ?? '',
      durationInMonths: proposal.durationInMonths ?? 0,
      fundsRequested: proposal.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      createdAt: proposal.id.ver!.dateTime,
      iteration: data.iteration,
      commentsCount: isFinal ? null : data.commentsCount,
      isFinal: isFinal,
      isFavorite: data.isFavorite,
      votes: isFinal ? ProposalBriefDataVotes(draft: draftVote, casted: castedVote) : null,
    );
  }
}
