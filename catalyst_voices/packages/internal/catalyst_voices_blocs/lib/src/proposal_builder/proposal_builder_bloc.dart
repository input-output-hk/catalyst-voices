import 'dart:async';

import 'package:catalyst_voices_blocs/src/comments/comments_state.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_event_transformers.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_signal_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/document_builder/document_builder.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_bloc_cache.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_signal.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBuilderBloc');

/// Manages proposal builder.
///
/// Handles loading of proposal, editing of proposal and comments, publishing of proposal and comments,
/// and other related actions.
final class ProposalBuilderBloc extends Bloc<ProposalBuilderEvent, ProposalBuilderState>
    with
        BlocErrorEmitterMixin,
        BlocSignalEmitterMixin<ProposalBuilderSignal, ProposalBuilderState> {
  final ProposalService _proposalService;
  final CampaignService _campaignService;
  final CommentService _commentService;
  final UserService _userService;
  final DownloaderService _downloaderService;
  final DocumentMapper _documentMapper;

  ProposalBuilderBlocCache _cache = const ProposalBuilderBlocCache();
  StreamSubscription<Account?>? _activeAccountSub;
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;
  StreamSubscription<bool>? _isMaxProposalsLimitReachedSub;

  ProposalBuilderBloc(
    this._proposalService,
    this._campaignService,
    this._commentService,
    this._userService,
    this._downloaderService,
    this._documentMapper,
  ) : super(const ProposalBuilderState()) {
    on<LoadDefaultProposalCategoryEvent>(_loadDefaultProposalCategory);
    on<LoadProposalCategoryEvent>(_loadProposalCategory);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveNodeChangedEvent>(
      _handleActiveNodeChangedEvent,
      transformer: uniqueEvents(),
    );
    on<SectionChangedEvent>(_handleSectionChangedEvent);
    on<DeleteProposalEvent>(_deleteProposal);
    on<ExportProposalEvent>(_exportProposal);
    on<PublishProposalEvent>(_publishProposal);
    on<RebuildCommentsProposalEvent>(_rebuildComments);
    on<RebuildActiveAccountProposalEvent>(_rebuildActiveAccount);
    on<SubmitProposalEvent>(_submitProposal);
    on<RequestPublishProposalEvent>(_requestPublishProposal);
    on<RequestSubmitProposalEvent>(_requestSubmitProposal);
    on<ValidateProposalEvent>(_validateProposal);
    on<UpdateProposalBuilderValidationStatusEvent>(_updateValidationStatus);
    on<ClearValidationProposalEvent>(_clearValidation);
    on<ProposalSubmissionCloseDateEvent>(_proposalSubmissionCloseDate);
    on<UpdateCommentsSortEvent>(_updateCommentsSort);
    on<UpdateCommentBuilderEvent>(_updateCommentBuilder);
    on<UpdateCommentRepliesEvent>(_updateCommentReplies);
    on<SubmitCommentEvent>(_submitComment);
    on<MaxProposalsLimitChangedEvent>(_updateMaxProposalsLimitReached);
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdateCollaboratorsEvent>(_updateCollaborators);
    on<UnlockProposalBuilderEvent>(_unlockProposal);
    on<ForgetProposalBuilderEvent>(_forgetProposal);

    final activeAccount = _userService.user.activeAccount;

    _cache = _cache.copyWith(
      activeAccountId: Optional(activeAccount?.catalystId),
      accountPublicStatus: Optional(activeAccount?.publicStatus),
    );

    _activeAccountSub = _userService.watchUnlockedActiveAccount.listen(
      (value) => add(RebuildActiveAccountProposalEvent(account: value)),
    );

    _isMaxProposalsLimitReachedSub = _proposalService.watchMaxProposalsLimitReached().listen((
      event,
    ) {
      add(MaxProposalsLimitChangedEvent(isLimitReached: event));
    });
  }

  @override
  Future<void> close() async {
    await _activeAccountSub?.cancel();
    _activeAccountSub = null;

    await _commentsSub?.cancel();
    _commentsSub = null;

    await _isMaxProposalsLimitReachedSub?.cancel();
    _isMaxProposalsLimitReachedSub = null;

    return super.close();
  }

  Future<bool> isAccountEmailVerified() async {
    try {
      return _userService.isActiveAccountPubliclyVerified();
    } catch (e) {
      return false;
    }
  }

  bool validate(ProposalBuilderValidationOrigin origin) {
    final document = _buildDocument();
    final isValid = document.isValid;
    add(ValidateProposalEvent(origin: origin));

    return isValid;
  }

  Document _buildDocument() {
    final proposalBuilder = _cache.proposalBuilder;
    assert(proposalBuilder != null, 'proposal builder not initialized');
    return proposalBuilder!.build();
  }

  DocumentData _buildDocumentData([DocumentRef? id]) {
    return DocumentData(
      metadata: _buildDocumentMetadata(id),
      content: _documentMapper.toContent(_buildDocument()),
    );
  }

  DocumentDataMetadata _buildDocumentMetadata([DocumentRef? id]) {
    return DocumentDataMetadata.proposal(
      id: id ?? state.metadata.documentRef!,
      template: state.metadata.templateRef!,
      parameters: state.metadata.parameters!,
      authors: [_userService.activeAccountId],
      collaborators: state.metadata.collaborators,
    );
  }

  ProposalBuilderState _buildState({
    required Document proposalDocument,
    required ProposalBuilderMetadata proposalMetadata,
    required CampaignCategory category,
    required CampaignCategoryTotalAsk categoryTotalAsk,
    required DocumentSchema? commentSchema,
    required List<CommentWithReplies> comments,
    required CommentsState commentsState,
    required bool hasActiveAccount,
    required bool isEmailVerified,
    required bool isMaxProposalsLimitReached,
    required bool hasAccountUsername,
  }) {
    final documentSegments = proposalDocument.createSegments(
      showValidationErrors: state.validationErrors?.showErrors ?? false,
    );

    final commentSegments = _mapCommentToSegments(
      originalProposalRef: proposalMetadata.originalDocumentRef,
      comments: comments,
      commentSchema: commentSchema,
      commentsState: commentsState,
      hasActiveAccount: hasActiveAccount,
      hasAccountUsername: hasAccountUsername,
    );

    final firstSegment = documentSegments.firstOrNull;
    final firstSection = firstSegment?.sections.firstOrNull;
    final guidance = DocumentBuilderGuidance.create(
      firstSegment,
      firstSection,
      titleGenerator: _getGuidanceCustomTitle,
    );
    final stateCategory = CampaignCategoryDetailsViewModel.fromModel(
      category,
      finalProposalsCount: categoryTotalAsk.finalProposalsCount,
      totalAsk: categoryTotalAsk.totalAsk,
    );

    return ProposalBuilderState(
      documentSegments: documentSegments,
      commentSegments: commentSegments,
      guidance: guidance,
      document: proposalDocument,
      metadata: proposalMetadata,
      category: stateCategory,
      activeNodeId: firstSection?.id,
      validationErrors: state.validationErrors?.withErrorList(
        proposalDocument.invalidPropertiesTitles,
      ),
      canPublish: isEmailVerified && proposalDocument.isValid,
      isMaxProposalsLimitReached: isMaxProposalsLimitReached,
    );
  }

  Future<ProposalBuilderState> _cacheAndCreateState({
    required Document proposalDocument,
    required DocumentBuilder proposalBuilder,
    required ProposalBuilderMetadata proposalMetadata,
    required CampaignCategory category,
    required CampaignCategoryTotalAsk categoryTotalAsk,
  }) async {
    final commentTemplate = await _commentService.getCommentTemplate(category: category.id);

    _cache = _cache.copyWith(
      proposalBuilder: Optional(proposalDocument.toBuilder()),
      proposalDocument: Optional(proposalDocument),
      proposalMetadata: Optional(proposalMetadata),
      category: Optional(category),
      commentTemplate: Optional(commentTemplate),
      comments: const Optional.empty(),
      categoryTotalAsk: Optional(categoryTotalAsk),
    );

    await _commentsSub?.cancel();

    final originalRef = proposalMetadata.originalDocumentRef;
    if (originalRef is SignedDocumentRef) {
      _commentsSub = _commentService
          // Note. watch comments on exact version of proposal.
          .watchCommentsWith(ref: originalRef)
          .distinct(listEquals)
          .listen(
            (value) => add(RebuildCommentsProposalEvent(comments: value)),
          );
    }

    return _rebuildState();
  }

  Future<void> _clearCache() async {
    final activeAccount = _userService.user.activeAccount;
    final isMaxProposalsLimitReached = await _proposalService.isMaxProposalsLimitReached();

    _cache = ProposalBuilderBlocCache(
      activeAccountId: activeAccount?.catalystId,
      accountPublicStatus: activeAccount?.publicStatus,
      isMaxProposalsLimitReached: isMaxProposalsLimitReached,
    );
  }

  void _clearValidation(
    ClearValidationProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final documentSegments = _cache.proposalDocument!.createSegments();

    emit(
      state.copyWith(
        documentSegments: documentSegments,
        validationErrors: const Optional.empty(),
      ),
    );
  }

  Future<void> _deleteProposal(
    DeleteProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      final ref = state.metadata.documentRef! as DraftRef;
      _logger.info('deleteProposal: $ref');
      emit(state.copyWith(isChanging: true));

      // removing all versions of this proposal
      final unversionedRef = ref.toLoose();

      await _proposalService.deleteDraftProposal(unversionedRef);
      emitSignal(const DeletedProposalBuilderSignal());
    } catch (error, stackTrace) {
      _logger.severe('Deleting proposal failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  Future<void> _exportProposal(
    ExportProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      final documentRef = state.metadata.documentRef!;
      final proposalId = documentRef.id;
      _logger.info('export proposal: $documentRef');
      emit(state.copyWith(isChanging: true));

      final encodedProposal = await _proposalService.encodeProposalForExport(
        document: _buildDocumentData(),
      );

      final filename = '${event.filePrefix}_$proposalId';
      const extension = ProposalDocument.exportFileExt;

      await _downloaderService.download(
        data: encodedProposal,
        filename: '$filename.$extension',
      );
    } catch (error, stackTrace) {
      _logger.severe('Exporting proposal failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  Future<void> _forgetProposal(
    ProposalBuilderEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final proposalId = state.metadata.documentRef;
    try {
      emit(state.copyWith(isChanging: true));

      await _proposalService.forgetProposal(
        proposalId: proposalId! as SignedDocumentRef,
      );
      unawaited(_clearCache());
      emitSignal(const ForgotProposalSuccessBuilderSignal());
    } catch (e, stackTrace) {
      _logger.severe('Error forgetting proposal', e, stackTrace);
      emitError(LocalizedException.create(e));
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  String? _getGuidanceCustomTitle(DocumentProperty property) {
    final milestoneListWildcard = ProposalDocument.milestoneListChildNodeId;
    return property.schema.nodeId.matchesPattern(milestoneListWildcard) ? '' : null;
  }

  DocumentBuilderGuidance _getGuidanceForNodeId(NodeId? nodeId) {
    if (nodeId == null) {
      return const DocumentBuilderGuidance(isNoneSelected: true);
    } else {
      final segment = state.documentSegments.firstWhereOrNull((e) => nodeId.isSameOrChildOf(e.id));
      final section = segment?.sections.firstWhereOrNull((e) => e.id == nodeId);

      return DocumentBuilderGuidance.create(
        segment,
        section,
        titleGenerator: _getGuidanceCustomTitle,
      );
    }
  }

  Future<DateTime?> _getProposalSubmissionCloseDate() async {
    // TODO(dt-iohk): consider to use campaign assigned to the proposal
    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      return null;
    }
    return campaign.timeline.phases
        .firstWhereOrNull(
          (e) => e.type == CampaignPhaseType.proposalSubmission,
        )
        ?.timeline
        .to;
  }

  void _handleActiveNodeChangedEvent(
    ActiveNodeChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final nodeId = event.id;
    _logger.info('Active node changed to [$nodeId]');

    emit(
      state.copyWith(
        activeNodeId: Optional(nodeId),
        guidance: _getGuidanceForNodeId(nodeId),
      ),
    );
  }

  Future<void> _handleSectionChangedEvent(
    SectionChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final proposalBuilder = _cache.proposalBuilder;
    assert(proposalBuilder != null, 'proposal builder not initialized');

    proposalBuilder!.addChanges(event.changes);
    final document = proposalBuilder.build();

    _cache = _cache.copyWith(proposalDocument: Optional(document));

    final documentSegments = document.createSegments(
      showValidationErrors: state.validationErrors?.showErrors ?? false,
    );

    final validationErrors = state.validationErrors?.withErrorList(
      document.invalidPropertiesTitles,
    );

    final newState = state.copyWith(
      document: Optional(document),
      documentSegments: documentSegments,
      validationErrors: Optional(validationErrors),
      canPublish: _cache.isEmailVerified && document.isValid,
    );

    // early emit new state to make the UI responsive
    emit(newState);

    // then proceed slow async operations
    await _saveDocumentLocally(emit, document);
  }

  bool _isLocal(ProposalPublish publish, int iteration) {
    return publish == ProposalPublish.localDraft && iteration == DocumentVersion.firstNumber;
  }

  Future<void> _loadDefaultProposalCategory(
    LoadDefaultProposalCategoryEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading default proposal category');

    await _loadState(emit, () async {
      final campaign = await _campaignService.getActiveCampaign();
      if (campaign == null) {
        throw StateError('Cannot load proposal, active campaign not found');
      }
      final category = campaign.categories.first;
      final categoryTotalAsk = await _campaignService.getCategoryTotalAsk(ref: category.id);

      final proposalTemplate = await _proposalService.getProposalTemplate(category: category.id);
      final templateParameters = proposalTemplate.metadata.parameters;
      final documentBuilder = DocumentBuilder.fromSchema(schema: proposalTemplate.schema);

      return _cacheAndCreateState(
        proposalDocument: documentBuilder.build(),
        proposalBuilder: documentBuilder,
        proposalMetadata: ProposalBuilderMetadata.newDraft(
          templateRef: proposalTemplate.metadata.id.toSignedDocumentRef(),
          parameters: templateParameters,
        ),
        category: category,
        categoryTotalAsk: categoryTotalAsk,
      );
    });
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final proposalRef = await _proposalService.getLatestProposalVersion(id: event.proposalId);

    if (state.metadata.documentRef == proposalRef) {
      _logger.info('Loading proposal: $proposalRef ignored, already loaded');
      return;
    } else {
      _logger.info('Loading proposal: $proposalRef');
    }

    await _loadState(emit, () async {
      final proposalData = await _proposalService.getProposalDetail(
        id: proposalRef,
      );
      final versionsIds = proposalData.versions.map((e) => e.id.ver).whereType<String>().toList();
      final proposal = Proposal.fromData(proposalData, versionsIds);

      if (proposalData.publish.isPublished) {
        emitSignal(
          UnlockProposalSignal(
            title: proposal.title,
            version: proposal.versionNumber,
          ),
        );
      }

      final versions = proposalData.versions.mapIndexed((index, version) {
        final versionRef = version.id;
        final versionId = versionRef.ver ?? versionRef.id;
        return DocumentVersion(
          id: versionId,
          number: index + 1,
          isCurrent: versionId == proposalRef.ver,
          isLatest: index == proposalData.versions.length - 1,
        );
      }).toList();
      final notVerifiedAccount =
          !(_userService.user.activeAccount?.publicStatus.isVerified ?? false);
      final firstVersion =
          versions.length == 1 && versions.first.number == DocumentVersion.firstNumber;
      if (firstVersion && proposalData.publish.isLocal && notVerifiedAccount) {
        emitSignal(const NewProposalAndEmailNotVerifiedSignal());
      }

      final category = await _campaignService.getCategory(proposal.parameters);
      final categoryTotalAsk = await _campaignService.getCategoryTotalAsk(ref: category.id);
      // TODO(dt-iohk): consider to use campaign assigned to the proposal
      final campaign = await _campaignService.getActiveCampaign();
      final fromActiveCampaign = campaign?.hasCategory(category.id.id) ?? false;

      return _cacheAndCreateState(
        proposalDocument: proposalData.document.document,
        proposalBuilder: proposalData.document.document.toBuilder(),
        proposalMetadata: ProposalBuilderMetadata(
          publish: proposal.publish,
          documentRef: proposal.id,
          originalDocumentRef: proposal.id,
          templateRef: proposalData.document.metadata.templateRef,
          parameters: proposalData.document.metadata.parameters,
          versions: versions,
          fromActiveCampaign: fromActiveCampaign,
          authorId: _cache.activeAccountId,
          collaborators: proposalData.document.metadata.collaborators ?? [],
        ),
        category: category,
        categoryTotalAsk: categoryTotalAsk,
      );
    });
  }

  Future<void> _loadProposalCategory(
    LoadProposalCategoryEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final categoryId = event.categoryId;
    _logger.info('Loading proposal category: $categoryId');

    await _loadState(emit, () async {
      final category = await _campaignService.getCategory(DocumentParameters({categoryId}));
      final proposalTemplate = await _proposalService.getProposalTemplate(category: categoryId);
      final templateParameters = proposalTemplate.metadata.parameters;

      final categoryTotalAsk = await _campaignService.getCategoryTotalAsk(ref: categoryId);

      final documentBuilder = DocumentBuilder.fromSchema(schema: proposalTemplate.schema);

      return _cacheAndCreateState(
        proposalDocument: documentBuilder.build(),
        proposalBuilder: documentBuilder,
        proposalMetadata: ProposalBuilderMetadata.newDraft(
          templateRef: proposalTemplate.metadata.id.toSignedDocumentRef(),
          parameters: templateParameters,
        ),
        category: category,
        categoryTotalAsk: categoryTotalAsk,
      );
    });
  }

  Future<void> _loadState(
    Emitter<ProposalBuilderState> emit,
    Future<ProposalBuilderState> Function() stateBuilder,
  ) async {
    try {
      _logger.info('load state');
      const loadingState = ProposalBuilderState(
        isLoading: true,
        isChanging: true,
      );

      emit(loadingState);
      await _clearCache();

      final newState = await stateBuilder();
      emit(newState);
    } catch (error, stackTrace) {
      _logger.severe('load state error', error, stackTrace);

      emit(ProposalBuilderState(error: LocalizedException.create(error)));
      await _clearCache();
    } finally {
      emit(
        state.copyWith(
          isLoading: false,
          isChanging: false,
        ),
      );
    }
  }

  List<Segment> _mapCommentToSegments({
    required DocumentRef? originalProposalRef,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required CommentsState commentsState,
    required bool hasActiveAccount,
    required bool hasAccountUsername,
  }) {
    final isDraftProposal = originalProposalRef == null || originalProposalRef is DraftRef;
    final isNotLocalAndHasActiveAccount = !isDraftProposal && hasActiveAccount;

    final canReply = isNotLocalAndHasActiveAccount && hasAccountUsername;
    final canComment = isNotLocalAndHasActiveAccount && commentSchema != null;

    if (canComment || comments.isNotEmpty) {
      return [
        ProposalCommentsSegment(
          id: const NodeId('comments'),
          sort: commentsState.commentsSort,
          sections: [
            ProposalViewCommentsSection(
              id: const NodeId('comments.view'),
              sort: commentsState.commentsSort,
              comments: commentsState.commentsSort.applyTo(comments),
              canReply: canReply,
            ),
            if (canComment)
              ProposalAddCommentSection(
                id: const NodeId('comments.add'),
                schema: commentSchema,
                showUsernameRequired: !hasActiveAccount,
              ),
          ],
        ),
      ];
    }

    return const [];
  }

  Future<void> _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final catId = _userService.user.activeAccount?.catalystId;
    if (catId == null) {
      _logger.warning('Tried to update username but no action account found');
      return;
    }

    try {
      final value = event.value;
      await _userService.updateAccount(
        id: catId,
        username: value.isNotEmpty ? Optional(value) : const Optional.empty(),
      );
    } catch (error, stackTrace) {
      _logger.severe('Update username failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    }
  }

  Future<void> _proposalSubmissionCloseDate(
    ProposalSubmissionCloseDateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final closeDate = await _getProposalSubmissionCloseDate();
    if (closeDate != null) {
      emitSignal(ProposalSubmissionCloseDate(date: closeDate));
    }
  }

  Future<void> _publishAndSubmitProposalForReview(
    Emitter<ProposalBuilderState> emit,
  ) async {
    final currentId = state.metadata.documentRef!;
    final updatedId = await _proposalService.publishProposal(
      document: _buildDocumentData(),
    );

    List<DocumentVersion>? updatedVersions;
    if (updatedId != currentId) {
      // if a new ref has been created we need to recreate
      // the version history to reflect it, drop the old one
      // because the new one overrode it
      updatedVersions = _recreateDocumentVersionsWithNewRef(
        newRef: updatedId,
        removedRef: currentId,
      );
    }

    _updateMetadata(
      emit,
      documentRef: updatedId,
      originalDocumentRef: updatedId,
      publish: ProposalPublish.publishedDraft,
      versions: updatedVersions,
    );

    await _proposalService.submitProposalForReview(proposalId: updatedId);

    _updateMetadata(
      emit,
      publish: ProposalPublish.submittedProposal,
    );

    emitSignal(const SubmittedProposalBuilderSignal());
  }

  Future<void> _publishProposal(
    PublishProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      _logger.info('Publishing proposal');
      emit(
        state.copyWith(
          isChanging: true,
          validationErrors: const Optional.empty(),
        ),
      );

      final currentRef = state.metadata.documentRef!;
      final updatedRef = await _proposalService.publishProposal(
        document: _buildDocumentData(),
      );

      List<DocumentVersion>? updatedVersions;
      if (updatedRef != currentRef) {
        // if a new ref has been created we need to recreate
        // the version history to reflect it, drop the old one
        // because the new one overrode it
        updatedVersions = _recreateDocumentVersionsWithNewRef(
          newRef: updatedRef,
          removedRef: currentRef,
        );
      }

      _updateMetadata(
        emit,
        documentRef: updatedRef,
        originalDocumentRef: updatedRef,
        publish: ProposalPublish.publishedDraft,
        versions: updatedVersions,
      );
      emitSignal(const PublishedProposalBuilderSignal());
    } on ProposalLimitReachedException {
      _logger.info('publishProposal: limit reached');
      emitError(const ProposalBuilderLimitReachedException());
    } on DocumentSignException catch (error, stackTrace) {
      _logger.severe('publishProposal: failed to sign the document', error, stackTrace);
      emitError(const ProposalBuilderDocumentSignException());
    } catch (error, stackTrace) {
      _logger.severe('publishProposal', error, stackTrace);

      emitError(
        LocalizedException.create(
          error,
          fallback: () => const ProposalBuilderPublishException(),
        ),
      );
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  void _rebuildActiveAccount(
    RebuildActiveAccountProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final account = event.account;
    _cache = _cache.copyWith(
      activeAccountId: Optional(account?.catalystId),
      accountPublicStatus: Optional(account?.publicStatus),
    );
    emit(_rebuildState());
  }

  void _rebuildComments(
    RebuildCommentsProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    _cache = _cache.copyWith(comments: Optional(event.comments));

    emit(_rebuildState());
  }

  ProposalBuilderState _rebuildState() {
    final activeAccountId = _cache.activeAccountId;
    final proposalDocument = _cache.proposalDocument;
    final proposalMetadata = _cache.proposalMetadata;
    final category = _cache.category;
    final categoryTotalAsk = _cache.categoryTotalAsk;
    final commentTemplate = _cache.commentTemplate;
    final comments = _cache.comments ?? [];
    final commentsState = state.comments;
    final isEmailVerified = _cache.isEmailVerified;
    final isMaxProposalsLimitReached = _cache.isMaxProposalsLimitReached ?? true;

    if (proposalDocument == null ||
        proposalMetadata == null ||
        category == null ||
        commentTemplate == null) {
      return const ProposalBuilderState(isLoading: true, isChanging: true);
    }

    final username = activeAccountId?.username;

    return _buildState(
      hasActiveAccount: activeAccountId != null,
      hasAccountUsername: username != null && !username.isBlank,
      proposalDocument: proposalDocument,
      proposalMetadata: proposalMetadata,
      category: category,
      categoryTotalAsk: categoryTotalAsk ?? CampaignCategoryTotalAsk.zero(category.id),
      commentSchema: commentTemplate.schema,
      comments: comments,
      commentsState: commentsState,
      isEmailVerified: isEmailVerified,
      isMaxProposalsLimitReached: isMaxProposalsLimitReached,
    );
  }

  List<DocumentVersion> _recreateDocumentVersionsWithNewRef({
    DocumentRef? newRef,
    DocumentRef? removedRef,
  }) {
    final current = state.metadata.versions.whereNot((e) => e.id == removedRef?.ver);
    final currentId = newRef?.ver ?? current.last.id;

    return [
      for (final (index, ver) in current.indexed)
        ver.copyWith(
          number: index + 1,
          isCurrent: ver.id == currentId,
          isLatest: ver.id == currentId,
        ),
      if (newRef != null)
        DocumentVersion(
          id: newRef.ver!,
          number: current.length + 1,
          isCurrent: newRef.ver == currentId,
          isLatest: newRef.ver == currentId,
        ),
    ];
  }

  Future<void> _requestPublishProposal(
    RequestPublishProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      emit(state.copyWith(isChanging: true));
      if (!await isAccountEmailVerified()) {
        emitSignal(const EmailNotVerifiedProposalBuilderSignal());
        return;
      }

      if (emit.isDone) {
        return;
      }

      if (!validate(ProposalBuilderValidationOrigin.shareDraft)) {
        return;
      }

      final proposalTitle = state.proposalTitle;
      final nextIteration = state.metadata.latestVersion?.number ?? DocumentVersion.firstNumber;
      final hasCollaborators = state.metadata.collaborators.isNotEmpty;

      // if it's local draft and the first version then
      // it should be shown as local which corresponds to null
      final currentIteration = _isLocal(state.metadata.publish, nextIteration)
          ? null
          : nextIteration - 1;

      emitSignal(
        ShowPublishConfirmationSignal(
          proposalTitle: proposalTitle,
          currentIteration: currentIteration,
          nextIteration: nextIteration,
          hasCollaborators: hasCollaborators,
        ),
      );
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  Future<void> _requestSubmitProposal(
    RequestSubmitProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      emit(state.copyWith(isChanging: true));
      if (state.isMaxProposalsLimitReached) {
        final proposalSubmissionCloseDate = await _getProposalSubmissionCloseDate();
        final activeAccountId = _userService.user.activeAccount?.catalystId;
        final count = activeAccountId == null
            ? 0
            : await _proposalService
                  .watchProposalsCountV2(
                    filters: ProposalsFiltersV2(
                      status: ProposalStatusFilter.aFinal,
                      relationships: {OriginalAuthor(activeAccountId)},
                    ),
                  )
                  .first;

        if (proposalSubmissionCloseDate != null) {
          final signal = MaxProposalsLimitReachedSignal(
            proposalSubmissionCloseDate: proposalSubmissionCloseDate,
            currentSubmissions: count,
            maxSubmissions: ProposalDocument.maxSubmittedProposalsPerUser,
          );

          emitSignal(signal);
        }

        return;
      }

      if (!await isAccountEmailVerified()) {
        emitSignal(const EmailNotVerifiedProposalBuilderSignal());
        return;
      }

      if (!validate(ProposalBuilderValidationOrigin.submitForReview)) {
        return;
      }

      if (emit.isDone) {
        return;
      }

      final proposalTitle = state.proposalTitle;
      final latestVersion = state.metadata.latestVersion;
      final nextIteration = latestVersion?.number ?? DocumentVersion.firstNumber;
      final hasCollaborators = state.metadata.collaborators.isNotEmpty;

      final int? currentIteration;
      if (_isLocal(state.metadata.publish, nextIteration)) {
        // if it's local draft and the first version then
        // it should be shown as local which corresponds to null
        currentIteration = null;
      } else if (state.metadata.publish == ProposalPublish.localDraft) {
        // current iteration is a local draft
        // so next iteration must increment the version
        currentIteration = nextIteration - 1;
      } else {
        // only changing status of the iteration, no need to increment the version
        currentIteration = nextIteration;
      }

      emitSignal(
        ShowSubmitConfirmationSignal(
          proposalTitle: proposalTitle,
          currentIteration: currentIteration,
          nextIteration: nextIteration,
          hasCollaborators: hasCollaborators,
        ),
      );
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  Future<void> _saveDocumentLocally(
    Emitter<ProposalBuilderState> emit,
    Document document,
  ) async {
    final currentRef = state.metadata.documentRef!;
    final updatedRef = await _upsertDraftProposal(
      _documentMapper.toContent(document),
    );

    List<DocumentVersion>? updatedVersions;
    if (updatedRef != currentRef) {
      // if a new ref has been created we need to recreate
      // the version history to reflect it
      updatedVersions = _recreateDocumentVersionsWithNewRef(newRef: updatedRef);
    }

    _updateMetadata(
      emit,
      documentRef: updatedRef,
      originalDocumentRef: state.metadata.originalDocumentRef ?? updatedRef,
      publish: ProposalPublish.localDraft,
      versions: updatedVersions,
    );
  }

  Future<void> _submitComment(
    SubmitCommentEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final originalProposalRef = state.metadata.originalDocumentRef;
    assert(
      originalProposalRef != null,
      'Proposal ref not found. Load document first!',
    );
    assert(
      originalProposalRef is SignedDocumentRef,
      'Can comment only on signed documents.',
    );

    final activeAccountId = _cache.activeAccountId;
    assert(activeAccountId != null, 'No active account found!');

    final commentTemplate = _cache.commentTemplate;
    assert(commentTemplate != null, 'No comment template found!');

    final commentRef = SignedDocumentRef.generateFirstRef();
    final comment = CommentDocument(
      metadata: CommentMetadata(
        id: commentRef,
        proposalRef: originalProposalRef! as SignedDocumentRef,
        commentTemplate: commentTemplate!.metadata.id as SignedDocumentRef,
        reply: event.reply,
        parameters: state.metadata.parameters!,
        authorId: activeAccountId!,
      ),
      document: event.document,
    );

    final comments = (_cache.comments ?? []).addComment(comment: comment);
    _cache = _cache.copyWith(comments: Optional(comments));
    emit(_rebuildState());

    final documentData = comment.toDocumentData(mapper: _documentMapper);

    try {
      await _commentService.submitComment(document: documentData);
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);

      final localizedException = LocalizedException.create(
        error,
        fallback: LocalizedUnknownPublishCommentException.new,
      );

      emitError(localizedException);

      final source = _cache.comments;
      final comments = (source ?? []).removeComment(ref: commentRef);
      _cache = _cache.copyWith(comments: Optional(comments));

      if (!isClosed) {
        emit(_rebuildState());
      }
    }
  }

  Future<void> _submitProposal(
    SubmitProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      _logger.info('Submitting proposal for review');
      emit(
        state.copyWith(
          isChanging: true,
          validationErrors: const Optional.empty(),
        ),
      );

      switch (state.metadata.publish) {
        case ProposalPublish.localDraft:
          await _publishAndSubmitProposalForReview(emit);
        case ProposalPublish.publishedDraft:
          await _submitProposalForReview(emit);
        case ProposalPublish.submittedProposal:
          // already submitted, do nothing
          break;
      }
    } on ProposalLimitReachedException {
      _logger.info('SubmitProposalForReview: limit reached');
      emitError(const ProposalBuilderLimitReachedException());
    } on DocumentSignException catch (error, stackTrace) {
      _logger.severe('publishProposal: failed to sign the document', error, stackTrace);
      emitError(const ProposalBuilderDocumentSignException());
    } catch (error, stackTrace) {
      _logger.severe('SubmitProposalForReview', error, stackTrace);

      emitError(
        LocalizedException.create(
          error,
          fallback: () => const ProposalBuilderSubmitException(),
        ),
      );
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  Future<void> _submitProposalForReview(
    Emitter<ProposalBuilderState> emit,
  ) async {
    await _proposalService.submitProposalForReview(
      proposalId: state.metadata.documentRef! as SignedDocumentRef,
    );

    _updateMetadata(emit, publish: ProposalPublish.submittedProposal);
    emitSignal(const SubmittedProposalBuilderSignal());
  }

  Future<void> _unlockProposal(
    UnlockProposalBuilderEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      final proposalId = state.metadata.documentRef! as SignedDocumentRef;

      emit(state.copyWith(isChanging: true));

      await _proposalService.unlockProposal(proposalId: proposalId);
      final updatedMetadata = state.metadata.copyWith(publish: ProposalPublish.publishedDraft);
      _cache = _cache.copyWith(proposalMetadata: Optional(updatedMetadata));
      emit(state.copyWith(metadata: updatedMetadata, isChanging: false));
    } catch (e, stackTrace) {
      _logger.severe('Unlock proposal failed', e, stackTrace);
      emitError(LocalizedException.create(e));
    }
  }

  void _updateCollaborators(
    UpdateCollaboratorsEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final stateMetadata = state.metadata.copyWith(collaborators: event.collaborators);
    _cache = _cache.copyWith(proposalMetadata: Optional(stateMetadata));
    emit(state.copyWith(metadata: stateMetadata));
  }

  Future<void> _updateCommentBuilder(
    UpdateCommentBuilderEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final updatedComments = state.comments.updateCommentBuilder(ref: event.ref, show: event.show);

    emit(state.copyWith(comments: updatedComments));
  }

  Future<void> _updateCommentReplies(
    UpdateCommentRepliesEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final updatedComments = state.comments.updateCommentReplies(ref: event.ref, show: event.show);

    emit(state.copyWith(comments: updatedComments));
  }

  Future<void> _updateCommentsSort(
    UpdateCommentsSortEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final updatedComments = state.comments.copyWith(commentsSort: event.sort);
    emit(state.copyWith(comments: updatedComments));
    emit(_rebuildState());
  }

  void _updateMaxProposalsLimitReached(
    MaxProposalsLimitChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    _cache = _cache.copyWith(
      isMaxProposalsLimitReached: Optional(event.isLimitReached),
    );
    emit(_rebuildState());
  }

  void _updateMetadata(
    Emitter<ProposalBuilderState> emit, {
    DocumentRef? documentRef,
    DocumentRef? originalDocumentRef,
    ProposalPublish? publish,
    List<DocumentVersion>? versions,
  }) {
    final updatedMetadata = state.metadata.copyWith(
      documentRef: documentRef != null ? Optional(documentRef) : null,
      originalDocumentRef: originalDocumentRef != null ? Optional(originalDocumentRef) : null,
      publish: publish,
      versions: versions,
    );

    final updatedState = state.copyWith(
      metadata: updatedMetadata,
    );

    emit(updatedState);
  }

  void _updateValidationStatus(
    UpdateProposalBuilderValidationStatusEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final validationErrors = state.validationErrors?.copyWith(status: event.status);

    final documentSegments = _cache.proposalDocument!.createSegments(
      showValidationErrors: validationErrors?.showErrors ?? false,
    );

    emit(
      state.copyWith(
        documentSegments: documentSegments,
        validationErrors: Optional(validationErrors),
      ),
    );
  }

  Future<DraftRef> _upsertDraftProposal(DocumentDataContent document) async {
    final currentRef = state.metadata.documentRef!;
    final originalRef = state.metadata.originalDocumentRef;
    final templateRef = state.metadata.templateRef!;
    final parameters = state.metadata.parameters!;

    DraftRef nextRef;
    if (originalRef == null) {
      nextRef = await _proposalService.createDraftProposal(
        content: document,
        templateRef: templateRef,
        parameters: parameters,
      );
    } else {
      nextRef = currentRef.nextVersion();
      await _proposalService.upsertDraftProposal(
        id: nextRef,
        content: document,
        templateRef: templateRef,
        parameters: parameters,
      );
    }

    return nextRef;
  }

  Future<void> _validateProposal(
    ValidateProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final document = _buildDocument();
    final showErrors = !document.isValid;

    final documentSegments = document.createSegments();

    if (showErrors) {
      final newState = state.copyWith(
        documentSegments: documentSegments,
        validationErrors: Optional(
          ProposalBuilderValidationErrors(
            status: DocumentBuilderValidationStatus.notStarted,
            origin: event.origin,
            errors: document.invalidPropertiesTitles,
          ),
        ),
      );
      emit(newState);
    } else {
      final newState = state.copyWith(
        documentSegments: documentSegments,
        validationErrors: const Optional.empty(),
      );
      emit(newState);
    }
  }
}
