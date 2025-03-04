import 'dart:async';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_event_transformers.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_signal_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_signal.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBuilderBloc');

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState>
    with
        BlocErrorEmitterMixin,
        BlocSignalEmitterMixin<ProposalBuilderSignal, ProposalBuilderState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final DownloaderService _downloaderService;
  final DocumentMapper _documentMapper;

  DocumentBuilder? _documentBuilder;

  ProposalBuilderBloc(
    this._campaignService,
    this._proposalService,
    this._downloaderService,
    this._documentMapper,
  ) : super(const ProposalBuilderState()) {
    on<LoadDefaultProposalTemplateEvent>(_loadDefaultProposalTemplate);
    on<LoadProposalTemplateEvent>(_loadProposalTemplate);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveNodeChangedEvent>(
      _handleActiveNodeChangedEvent,
      transformer: uniqueEvents(),
    );
    on<SectionChangedEvent>(_handleSectionChangedEvent);
    on<DeleteProposalEvent>(_deleteProposal);
    on<ExportProposalEvent>(_exportProposal);
    on<PublishProposalEvent>(_publishProposal);
    on<SubmitProposalEvent>(_submitProposal);
    on<ValidateProposalEvent>(_validateProposal);
  }

  bool validate() {
    final document = _buildDocument();
    final isValid = document.isValid;
    add(const ValidateProposalEvent());

    return isValid;
  }

  Document _buildDocument() {
    final documentBuilder = _documentBuilder;
    assert(documentBuilder != null, 'DocumentBuilder not initialized');
    return documentBuilder!.build();
  }

  DocumentDataMetadata _buildDocumentMetadata() {
    return DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      selfRef: state.metadata.documentRef!,
      template: state.metadata.templateRef,
    );
  }

  ProposalBuilderState _createState({
    required Document document,
    required ProposalBuilderMetadata metadata,
  }) {
    final segments = _mapDocumentToSegments(
      document,
      showValidationErrors: state.showValidationErrors,
    );

    final firstSegment = segments.firstOrNull;
    final firstSection = firstSegment?.sections.firstOrNull;
    final guidance = _getGuidanceForSection(firstSegment, firstSection);

    return ProposalBuilderState(
      segments: segments,
      guidance: guidance,
      document: document,
      metadata: metadata,
      activeNodeId: firstSection?.id,
    );
  }

  Future<void> _deleteProposal(
    DeleteProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      emit(state.copyWith(isChanging: true));

      final ref = state.metadata.documentRef! as DraftRef;

      // removing all versions of this proposal
      final unversionedRef = ref.copyWith(version: const Optional.empty());

      await _proposalService.deleteDraftProposal(unversionedRef);
      emitSignal(const DeletedProposalBuilderSignal());
    } catch (error, stackTrace) {
      _logger.severe('Deleting proposal failed', error, stackTrace);
      emitError(const LocalizedUnknownException());
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
      final document = _buildDocument();

      final encodedProposal = await _proposalService.encodeProposalForExport(
        metadata: _buildDocumentMetadata(),
        content: _documentMapper.toContent(document),
      );

      final filename = '${event.filePrefix}_$proposalId';
      const extension = ProposalDocument.exportFileExt;

      await _downloaderService.download(
        data: encodedProposal,
        filename: '$filename.$extension',
      );
    } catch (error, stackTrace) {
      _logger.severe('Exporting proposal failed', error, stackTrace);
      emitError(const LocalizedUnknownException());
    }
  }

  Iterable<ProposalGuidanceItem> _findGuidanceItems(
    ProposalBuilderSegment segment,
    ProposalBuilderSection section,
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

  Iterable<DocumentProperty> _findSectionsAndSubsections(
    DocumentProperty property,
  ) sync* {
    if (property.schema.isSectionOrSubsection) {
      yield property;
    }

    switch (property) {
      case DocumentListProperty():
        for (final childProperty in property.properties) {
          yield* _findSectionsAndSubsections(childProperty);
        }
      case DocumentObjectProperty():
        for (final childProperty in property.properties) {
          yield* _findSectionsAndSubsections(childProperty);
        }
      case DocumentValueProperty():
      // value property doesn't have children
    }
  }

  ProposalGuidance _getGuidanceForNodeId(NodeId? nodeId) {
    if (nodeId == null) {
      return const ProposalGuidance(isNoneSelected: true);
    } else {
      final segment =
          state.segments.firstWhereOrNull((e) => nodeId.isChildOf(e.id));
      final section = segment?.sections.firstWhereOrNull((e) => e.id == nodeId);

      return _getGuidanceForSection(segment, section);
    }
  }

  ProposalGuidance _getGuidanceForSection(
    ProposalBuilderSegment? segment,
    ProposalBuilderSection? section,
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
    final documentBuilder = _documentBuilder;
    assert(documentBuilder != null, 'DocumentBuilder not initialized');

    documentBuilder!.addChanges(event.changes);
    final document = documentBuilder.build();

    final segments = _mapDocumentToSegments(
      document,
      showValidationErrors: state.showValidationErrors,
    );

    final newState = state.copyWith(
      document: Optional(document),
      segments: segments,
    );

    // early emit new state to make the UI responsive
    emit(newState);

    // then proceed slow async operations
    final ref = state.metadata.documentRef!;
    await _saveDocumentLocally(emit, ref, document);
  }

  Future<void> _loadDefaultProposalTemplate(
    LoadDefaultProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading default proposal template');

    await _loadState(emit, () async {
      final campaign = await _campaignService.getActiveCampaign();
      final proposalTemplateRef = campaign?.proposalTemplateRef;
      if (proposalTemplateRef == null) {
        throw const ActiveCampaignNotFoundException();
      }

      final proposalTemplate = await _proposalService.getProposalTemplate(
        ref: proposalTemplateRef,
      );

      final documentBuilder =
          DocumentBuilder.fromSchema(schema: proposalTemplate.schema);

      return _createState(
        document: documentBuilder.build(),
        metadata: ProposalBuilderMetadata.newDraft(
          templateRef: proposalTemplateRef,
        ),
      );
    });
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal[${event.id}]');

    await _loadState(emit, () async {
      final proposal = await _proposalService.getProposal(id: event.id);

      return _createState(
        document: proposal.document.document,
        metadata: ProposalBuilderMetadata(
          publish: proposal.publish,
          documentRef: proposal.ref,
          currentIteration: proposal.version,
        ),
      );
    });
  }

  Future<void> _loadProposalTemplate(
    LoadProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal template[${event.id}]');

    await _loadState(emit, () async {
      final proposalTemplateRef = SignedDocumentRef(id: event.id);
      final proposalTemplate = await _proposalService.getProposalTemplate(
        ref: proposalTemplateRef,
      );

      final documentBuilder =
          DocumentBuilder.fromSchema(schema: proposalTemplate.schema);

      return _createState(
        document: documentBuilder.build(),
        metadata: ProposalBuilderMetadata.newDraft(
          templateRef: proposalTemplateRef,
        ),
      );
    });
  }

  Future<void> _loadState(
    Emitter<ProposalBuilderState> emit,
    Future<ProposalBuilderState> Function() stateBuilder,
  ) async {
    try {
      emit(const ProposalBuilderState(isChanging: true));
      _documentBuilder = null;

      final newState = await stateBuilder();
      _documentBuilder = newState.document?.toBuilder();
      emit(newState);
    } on LocalizedException catch (error) {
      emit(ProposalBuilderState(error: error));
    } catch (error) {
      emit(const ProposalBuilderState(error: LocalizedUnknownException()));
    } finally {
      emit(state.copyWith(isChanging: false));
    }
  }

  List<ProposalBuilderSegment> _mapDocumentToSegments(
    Document document, {
    required bool showValidationErrors,
  }) {
    return document.segments.map((segment) {
      final sections = segment.sections
          .expand(_findSectionsAndSubsections)
          .map(
            (section) => ProposalBuilderSection(
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

      return ProposalBuilderSegment(
        id: segment.schema.nodeId,
        sections: sections,
        property: segment,
        schema: segment.schema as DocumentSegmentSchema,
      );
    }).toList();
  }

  Future<void> _publishProposal(
    PublishProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      _logger.info('Publishing proposal');
      final document = _buildDocument();
      await _proposalService.publishProposal(document);
    } catch (error, stackTrace) {
      _logger.severe('PublishProposal', error, stackTrace);
      emitError(error);
    }
  }

  Future<void> _saveDocumentLocally(
    Emitter<ProposalBuilderState> emit,
    DocumentRef ref,
    Document document,
  ) async {
    final ref = state.metadata.documentRef!;
    final nextRef = await _updateDraftProposal(
      ref,
      _documentMapper.toContent(document),
    );

    if (nextRef != null && ref != nextRef) {
      final updatedMetadata = state.metadata.copyWith(
        documentRef: Optional(nextRef),
      );
      final updatedState = state.copyWith(metadata: updatedMetadata);
      emit(updatedState);
    }
  }

  Future<void> _submitProposal(
    SubmitProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      _logger.info('Submitting proposal for review');
      final document = _buildDocument();
      await _proposalService.submitProposalForReview(document);
    } catch (error, stackTrace) {
      _logger.severe('SubmitProposalForReview', error, stackTrace);
      emitError(error);
    }
  }

  Future<DraftRef?> _updateDraftProposal(
    DocumentRef currentRef,
    DocumentDataContent document,
  ) async {
    final nextRef = currentRef.nextVersion();
    await _proposalService.updateDraftProposal(
      ref: nextRef,
      content: document,
    );

    return nextRef;
  }

  Future<void> _validateProposal(
    ValidateProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    final document = _buildDocument();
    final showErrors = !document.isValid;

    final segments = _mapDocumentToSegments(
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
      segments: segments,
      showValidationErrors: showErrors,
    );

    emit(newState);
  }
}
