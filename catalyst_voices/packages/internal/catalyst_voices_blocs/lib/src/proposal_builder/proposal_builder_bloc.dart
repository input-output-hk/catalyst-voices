import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

final _logger = Logger('ProposalBuilderBloc');

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  DocumentBuilder? _documentBuilder;
  NodeId? _activeNodeId;

  ProposalBuilderBloc(
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalBuilderState()) {
    on<LoadDefaultProposalTemplateEvent>(_loadDefaultProposalTemplate);
    on<LoadProposalTemplateEvent>(_loadProposalTemplate);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveNodeChangedEvent>(
      _handleActiveStepEvent,
      transformer: (events, mapper) => events.distinct(),
    );
  }

  Future<void> _loadDefaultProposalTemplate(
    LoadDefaultProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    try {
      _logger.info('Loading default proposal template');

      emit(const ProposalBuilderState(isLoading: true));

      _documentBuilder = null;

      final campaign = await _campaignService.getActiveCampaign();

      final proposalTemplate = campaign?.proposalTemplate;

      if (proposalTemplate == null) {
        // TODO(damian-molinski): return better exception
        emit(const ProposalBuilderState(error: LocalizedUnknownException()));
        return;
      }

      final newDocumentId = const Uuid().v7();
      final documentBuilder = DocumentBuilder.fromSchema(
        documentId: newDocumentId,
        documentVersion: newDocumentId,
        // TODO(damian-molinski): not sure what should go here.
        schemaUrl: proposalTemplate.propertiesSchema,
        schema: proposalTemplate,
      );

      final document = documentBuilder.build();
      final segments = _mapDocumentToSegments(document);

      emit(ProposalBuilderState(segments: segments));

      _documentBuilder = documentBuilder;
    } catch (error) {
      emit(const ProposalBuilderState(error: LocalizedUnknownException()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _loadProposalTemplate(
    LoadProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal template[${event.id}]');

    final proposalTemplate = await _proposalService.getProposalTemplate(
      id: event.id,
    );
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal[${event.id}]');

    final proposal = await _proposalService.getProposal(id: event.id);
  }

  void _handleActiveStepEvent(
    ActiveNodeChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    _logger.info('Active node changed to [${event.id}]');

    _activeNodeId = event.id;
  }

  List<Segment> _mapDocumentToSegments(Document document) {
    return document.segments.map((segment) {
      final sections = segment.sections.map(
        (section) {
          return ProposalBuilderSection(
            id: section.schema.nodeId,
            documentSection: section,
            isEnabled: true,
            isEditable: true,
          );
        },
      ).toList();

      return ProposalBuilderSegment(
        id: segment.schema.nodeId,
        sections: sections,
        documentSegment: segment,
      );
    }).toList();
  }
}
