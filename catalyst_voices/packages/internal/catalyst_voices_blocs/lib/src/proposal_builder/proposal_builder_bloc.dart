import 'dart:async';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_event_transformers.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_signal_emitter_mixin.dart';
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

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState>
    with
        BlocErrorEmitterMixin,
        BlocSignalEmitterMixin<ProposalBuilderSignal, ProposalBuilderState> {
  final ProposalService _proposalService;
  final CampaignService _campaignService;
  final CommentService _commentService;
  final DownloaderService _downloaderService;
  final DocumentMapper _documentMapper;

  ProposalBuilderBlocCache _cache = const ProposalBuilderBlocCache();
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;

  ProposalBuilderBloc(
    this._proposalService,
    this._campaignService,
    this._commentService,
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
    on<SubmitProposalEvent>(_submitProposal);
    on<ValidateProposalEvent>(_validateProposal);
  }

  @override
  Future<void> close() async {
    await _commentsSub?.cancel();
    _commentsSub = null;

    return super.close();
  }

  bool validate() {
    final document = _buildDocument();
    final isValid = document.isValid;
    add(const ValidateProposalEvent());

    return isValid;
  }

  Document _buildDocument() {
    final proposalBuilder = _cache.proposalBuilder;
    assert(proposalBuilder != null, 'proposal builder not initialized');
    return proposalBuilder!.build();
  }

  DocumentData _buildDocumentData([DocumentRef? selfRef]) {
    return DocumentData(
      metadata: _buildDocumentMetadata(selfRef),
      content: _documentMapper.toContent(_buildDocument()),
    );
  }

  DocumentDataMetadata _buildDocumentMetadata([DocumentRef? selfRef]) {
    return DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      selfRef: selfRef ?? state.metadata.documentRef!,
      template: state.metadata.templateRef,
      categoryId: state.metadata.categoryId,
    );
  }

  ProposalBuilderState _buildState({
    required Document proposalDocument,
    required ProposalBuilderMetadata proposalMetadata,
    required CampaignCategory category,
    required DocumentSchema? commentSchema,
    required List<CommentWithReplies> comments,
    required ProposalCommentsSort commentsSort,
  }) {
    final documentSegments = _mapDocumentToSegments(
      proposalDocument,
      showValidationErrors: state.showValidationErrors,
    );

    final commentsSegment = _mapToCommentsSegment(
      proposalRef: proposalMetadata.documentRef!,
      comments: comments,
      commentSchema: commentSchema,
      commentsSort: commentsSort,
    );

    final firstSegment = documentSegments.firstOrNull;
    final firstSection = firstSegment?.sections.firstOrNull;
    final guidance = _getGuidanceForSection(firstSegment, firstSection);
    final categoryVM = CampaignCategoryDetailsViewModel.fromModel(category);

    return ProposalBuilderState(
      documentSegments: documentSegments,
      commentsSegment: commentsSegment,
      guidance: guidance,
      document: proposalDocument,
      metadata: proposalMetadata,
      category: categoryVM,
      activeNodeId: firstSection?.id,
    );
  }

  Future<ProposalBuilderState> _cacheAndCreateState({
    required Document proposalDocument,
    required DocumentBuilder proposalBuilder,
    required ProposalBuilderMetadata proposalMetadata,
    required CampaignCategory category,
  }) async {
    final commentTemplate =
        await _commentService.getCommentTemplateFor(category: category.selfRef);

    _cache = _cache.copyWith(
      proposalBuilder: Optional(proposalDocument.toBuilder()),
      proposalDocument: Optional(proposalDocument),
      proposalMetadata: Optional(proposalMetadata),
      category: Optional(category),
      commentTemplate: Optional(commentTemplate),
      comments: const Optional.empty(),
    );

    await _commentsSub?.cancel();
    _commentsSub = _commentService
        // TODO(dtscalac): exact version or loose version
        // Note. watch comments on exact version of proposal.
        .watchCommentsWith(ref: proposalMetadata.documentRef!)
        .distinct(listEquals)
        .listen((value) => add(RebuildCommentsProposalEvent(comments: value)));

    return _rebuildState();
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
      final unversionedRef = ref.copyWith(version: const Optional.empty());

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

  Iterable<ProposalGuidanceItem> _findGuidanceItems(
    DocumentSegment segment,
    DocumentSection section,
    DocumentProperty property,
  ) sync* {
    final guidance = property.schema.guidance;
    if (guidance != null) {
      yield ProposalGuidanceItem(
        segmentTitle: segment.schema.title,
        sectionTitle: section.schema.title,
        description: guidance,
      );
    }

    switch (property) {
      case DocumentListProperty():
        for (final childProperty in property.properties) {
          yield* _findGuidanceItems(segment, section, childProperty);
        }
      case DocumentObjectProperty():
        for (final childProperty in property.properties) {
          yield* _findGuidanceItems(segment, section, childProperty);
        }
      case DocumentValueProperty():
      // do nothing, values don't have children
    }
  }

  ProposalGuidance _getGuidanceForNodeId(NodeId? nodeId) {
    if (nodeId == null) {
      return const ProposalGuidance(isNoneSelected: true);
    } else {
      final segment = state.documentSegments
          .firstWhereOrNull((e) => nodeId.isChildOf(e.id));
      final section = segment?.sections.firstWhereOrNull((e) => e.id == nodeId);

      return _getGuidanceForSection(segment, section);
    }
  }

  ProposalGuidance _getGuidanceForSection(
    DocumentSegment? segment,
    DocumentSection? section,
  ) {
    if (segment == null || section == null) {
      return const ProposalGuidance();
    } else {
      return ProposalGuidance(
        guidanceList:
            _findGuidanceItems(segment, section, section.property).toList(),
      );
    }
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

    final documentSegments = _mapDocumentToSegments(
      document,
      showValidationErrors: state.showValidationErrors,
    );

    final newState = state.copyWith(
      document: Optional(document),
      documentSegments: documentSegments,
    );

    // early emit new state to make the UI responsive
    emit(newState);

    // then proceed slow async operations
    await _saveDocumentLocally(emit, document);
  }

  Future<void> _loadDefaultProposalCategory(
    LoadDefaultProposalCategoryEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading default proposal category');

    await _loadState(emit, () async {
      final categories = await _campaignService.getCampaignCategories();
      final category = categories.first;
      final templateRef = category.proposalTemplateRef;

      final proposalTemplate = await _proposalService.getProposalTemplate(
        ref: templateRef,
      );

      final documentBuilder =
          DocumentBuilder.fromSchema(schema: proposalTemplate.schema);

      return _cacheAndCreateState(
        proposalDocument: documentBuilder.build(),
        proposalBuilder: documentBuilder,
        proposalMetadata: ProposalBuilderMetadata.newDraft(
          templateRef: templateRef,
          categoryId: category.selfRef,
        ),
        category: category,
      );
    });
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal: ${event.proposalId}');

    await _loadState(emit, () async {
      final proposalData = await _proposalService.getProposal(
        ref: event.proposalId,
      );
      final proposal = Proposal.fromData(proposalData);

      final versions = proposalData.versions.mapIndexed((index, version) {
        final versionRef = version.document.metadata.selfRef;
        final versionId = versionRef.version ?? versionRef.id;
        return DocumentVersion(
          id: versionId,
          number: index + 1,
          isCurrent: versionId == event.proposalId.version,
          isLatest: index == proposalData.versions.length - 1,
        );
      }).toList();

      final categoryId = proposalData.categoryId;
      final category = await _campaignService.getCategory(categoryId);

      return _cacheAndCreateState(
        proposalDocument: proposalData.document.document,
        proposalBuilder: proposalData.document.document.toBuilder(),
        proposalMetadata: ProposalBuilderMetadata(
          publish: proposal.publish,
          documentRef: proposal.selfRef,
          originalDocumentRef: proposal.selfRef,
          templateRef: proposalData.templateRef,
          categoryId: categoryId,
          versions: versions,
        ),
        category: category,
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
      final category = await _campaignService.getCategory(categoryId);
      final templateRef = category.proposalTemplateRef;
      final proposalTemplate = await _proposalService.getProposalTemplate(
        ref: templateRef,
      );

      final documentBuilder =
          DocumentBuilder.fromSchema(schema: proposalTemplate.schema);

      return _cacheAndCreateState(
        proposalDocument: documentBuilder.build(),
        proposalBuilder: documentBuilder,
        proposalMetadata: ProposalBuilderMetadata.newDraft(
          templateRef: templateRef,
          categoryId: categoryId,
        ),
        category: category,
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
      _cache = const ProposalBuilderBlocCache();

      final newState = await stateBuilder();
      emit(newState);
    } catch (error, stackTrace) {
      _logger.severe('load state error', error, stackTrace);

      emit(ProposalBuilderState(error: LocalizedException.create(error)));
      _cache = const ProposalBuilderBlocCache();
    } finally {
      emit(
        state.copyWith(
          isLoading: false,
          isChanging: false,
        ),
      );
    }
  }

  List<DocumentSegment> _mapDocumentToSegments(
    Document document, {
    required bool showValidationErrors,
  }) {
    return document.segments.map((segment) {
      final sections = segment.sections
          .expand(DocumentNodeTraverser.findSectionsAndSubsections)
          .map(
            (section) => DocumentSection(
              id: section.schema.nodeId,
              property: section,
              schema: section.schema,
              isEnabled: true,
              isEditable: true,
              hasError:
                  showValidationErrors && !section.isValidExcludingSubsections,
            ),
          )
          .toList();

      return DocumentSegment(
        id: segment.schema.nodeId,
        sections: sections,
        property: segment,
        schema: segment.schema as DocumentSegmentSchema,
      );
    }).toList();
  }

  ProposalCommentsSegment? _mapToCommentsSegment({
    required DocumentRef proposalRef,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
  }) {
    // TODO(dtscalac): should not allow comments if never published
    if (commentSchema == null) {
      return null;
    }

    return ProposalCommentsSegment(
      id: const NodeId('comments'),
      sort: commentsSort,
      sections: [
        ViewCommentsSection(
          id: const NodeId('comments.view'),
          comments: commentsSort.applyTo(comments),
          canReply: true,
        ),
        AddCommentSection(
          id: const NodeId('comments.add'),
          schema: commentSchema,
        ),
      ],
    );
  }

  Future<void> _publishAndSubmitProposalForReview(
    Emitter<ProposalBuilderState> emit,
  ) async {
    final updatedRef = await _proposalService.publishProposal(
      document: _buildDocumentData(),
    );

    _updateMetadata(
      emit,
      documentRef: updatedRef,
      publish: ProposalPublish.localDraft,
    );

    await _proposalService.submitProposalForReview(
      ref: updatedRef,
      categoryId: state.metadata.categoryId!,
    );

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
      emit(state.copyWith(isChanging: true));

      final updatedRef = await _proposalService.publishProposal(
        document: _buildDocumentData(),
      );

      _updateMetadata(
        emit,
        documentRef: updatedRef,
        publish: ProposalPublish.publishedDraft,
      );
      emitSignal(const PublishedProposalBuilderSignal());
    } catch (error, stackTrace) {
      _logger.severe('PublishProposal', error, stackTrace);
      emitError(const ProposalBuilderPublishException());
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  void _rebuildComments(
    RebuildCommentsProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    _cache = _cache.copyWith(comments: Optional(event.comments));

    emit(_rebuildState());
  }

  ProposalBuilderState _rebuildState() {
    final proposalDocument = _cache.proposalDocument!;
    final proposalMetadata = _cache.proposalMetadata!;
    final category = _cache.category!;
    final commentTemplate = _cache.commentTemplate!;
    final comments = _cache.comments ?? [];
    final commentsSort = state.commentsSort;

    return _buildState(
      proposalDocument: proposalDocument,
      proposalMetadata: proposalMetadata,
      category: category,
      commentSchema: commentTemplate.schema,
      comments: comments,
      commentsSort: commentsSort,
    );
  }

  Future<void> _saveDocumentLocally(
    Emitter<ProposalBuilderState> emit,
    Document document,
  ) async {
    final updatedRef = await _upsertDraftProposal(
      state.metadata.documentRef!,
      _documentMapper.toContent(document),
    );

    _updateMetadata(emit, documentRef: updatedRef);
  }

  Future<void> _submitProposal(
    SubmitProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      _logger.info('Submitting proposal for review');
      emit(state.copyWith(isChanging: true));

      switch (state.metadata.publish) {
        case ProposalPublish.localDraft:
          await _publishAndSubmitProposalForReview(emit);
        case ProposalPublish.publishedDraft:
          await _submitProposalForReview(emit);
        case ProposalPublish.submittedProposal:
          // already submitted, do nothing
          break;
      }
    } catch (error, stackTrace) {
      _logger.severe('SubmitProposalForReview', error, stackTrace);
      emitError(const ProposalBuilderSubmitException());
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  Future<void> _submitProposalForReview(
    Emitter<ProposalBuilderState> emit,
  ) async {
    await _proposalService.submitProposalForReview(
      ref: state.metadata.documentRef! as SignedDocumentRef,
      categoryId: state.metadata.categoryId!,
    );

    _updateMetadata(emit, publish: ProposalPublish.submittedProposal);
    emitSignal(const SubmittedProposalBuilderSignal());
  }

  void _updateMetadata(
    Emitter<ProposalBuilderState> emit, {
    DocumentRef? documentRef,
    ProposalPublish? publish,
  }) {
    final updatedMetadata = state.metadata.copyWith(
      documentRef: documentRef != null ? Optional(documentRef) : null,
      originalDocumentRef: documentRef != null ? Optional(documentRef) : null,
      publish: publish,
    );

    final updatedState = state.copyWith(
      metadata: updatedMetadata,
    );

    emit(updatedState);
  }

  Future<DraftRef> _upsertDraftProposal(
    DocumentRef currentRef,
    DocumentDataContent document,
  ) async {
    final originalRef = state.metadata.originalDocumentRef;
    final template = state.metadata.templateRef!;
    final categoryId = state.metadata.categoryId!;

    DraftRef nextRef;
    if (originalRef == null) {
      nextRef = await _proposalService.createDraftProposal(
        content: document,
        template: template,
        categoryId: categoryId,
      );
    } else {
      nextRef = currentRef.nextVersion();
      await _proposalService.upsertDraftProposal(
        selfRef: nextRef,
        content: document,
        template: template,
        categoryId: categoryId,
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

    final documentSegments = _mapDocumentToSegments(
      document,
      showValidationErrors: showErrors,
    );

    if (showErrors) {
      emitError(
        ProposalBuilderValidationException(
          fields:
              document.invalidProperties.map((e) => e.schema.title).toList(),
        ),
      );
    }

    final newState = state.copyWith(
      documentSegments: documentSegments,
      showValidationErrors: showErrors,
    );

    emit(newState);
  }
}
