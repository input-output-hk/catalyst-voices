import 'package:catalyst_voices_blocs/src/common/bloc_event_transformers.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
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
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  DocumentBuilder? _documentBuilder;

  ProposalBuilderBloc(
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalBuilderState()) {
    on<LoadDefaultProposalTemplateEvent>(_loadDefaultProposalTemplate);
    on<LoadProposalTemplateEvent>(_loadProposalTemplate);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveNodeChangedEvent>(
      _handleActiveNodeChangedEvent,
      transformer: uniqueEvents(),
    );
    on<SectionChangedEvent>(_handleSectionChangedEvent);
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

  void _handleSectionChangedEvent(
    SectionChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final documentBuilder = _documentBuilder;
    assert(documentBuilder != null, 'DocumentBuilder not initialized');

    documentBuilder!.addChanges(event.changes);
    final document = documentBuilder.build();
    final segments = _mapDocumentToSegments(document);

    emit(state.copyWith(segments: segments));
  }

  Future<void> _loadDefaultProposalTemplate(
    LoadDefaultProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    await _loadDocument(
      documentBuilderGetter: () async {
        _logger.info('Loading default proposal template');

        final campaign = await _campaignService.getActiveCampaign();

        final proposalTemplateRef = campaign?.proposalTemplateRef;

        if (proposalTemplateRef == null) {
          throw const ActiveCampaignNotFoundException();
        }

        final proposalTemplate = await _proposalService.getProposalTemplate(
          ref: proposalTemplateRef,
        );

        return DocumentBuilder.fromSchema(schema: proposalTemplate.schema);
      },
      emit: emit,
    );
  }

  Future<void> _loadProposalTemplate(
    LoadProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    await _loadDocument(
      documentBuilderGetter: () async {
        _logger.info('Loading proposal template[${event.id}]');

        final ref = DocumentRef(id: event.id);
        final proposalTemplate = await _proposalService.getProposalTemplate(
          ref: ref,
        );

        return DocumentBuilder.fromSchema(schema: proposalTemplate.schema);
      },
      emit: emit,
    );
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    await _loadDocument(
      documentBuilderGetter: () async {
        _logger.info('Loading proposal[${event.id}]');

        final proposal = await _proposalService.getProposal(id: event.id);
        final document = proposal.document.document;

        return DocumentBuilder.fromDocument(document);
      },
      emit: emit,
    );
  }

  Future<void> _loadDocument({
    required AsyncValueGetter<DocumentBuilder> documentBuilderGetter,
    required Emitter<ProposalBuilderState> emit,
  }) async {
    try {
      _logger.finer('Changing source to new document');

      emit(const ProposalBuilderState(isLoading: true));

      _documentBuilder = null;

      final documentBuilder = await documentBuilderGetter();

      _documentBuilder = documentBuilder;

      final document = documentBuilder.build();
      final segments = _mapDocumentToSegments(document);

      final firstSegment = segments.firstOrNull;
      final firstSection = firstSegment?.sections.firstOrNull;
      final guidance = _getGuidanceForSection(firstSegment, firstSection);

      emit(
        ProposalBuilderState(
          segments: segments,
          guidance: guidance,
          activeNodeId: firstSection?.id,
        ),
      );
    } on LocalizedException catch (error) {
      emit(ProposalBuilderState(error: error));
    } catch (error) {
      emit(const ProposalBuilderState(error: LocalizedUnknownException()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  List<ProposalBuilderSegment> _mapDocumentToSegments(Document document) {
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
}
