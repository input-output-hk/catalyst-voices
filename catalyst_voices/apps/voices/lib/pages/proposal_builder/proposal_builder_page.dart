import 'dart:async';

import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_error.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_loading.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_navigation_panel.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_segments.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_setup_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderPage extends StatefulWidget {
  final String? proposalId;
  final String? templateId;

  const ProposalBuilderPage({
    super.key,
    this.proposalId,
    this.templateId,
  });

  @override
  State<ProposalBuilderPage> createState() => _ProposalBuilderPageState();
}

class _ProposalBuilderPageState extends State<ProposalBuilderPage> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _segmentsScrollController;

  StreamSubscription<dynamic>? _segmentsSub;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalBuilderBloc>();

    _segmentsController = SegmentsController();
    _segmentsScrollController = ItemScrollController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_segmentsScrollController);

    _segmentsSub = bloc.stream
        .map((event) => (segments: event.segments, nodeId: event.activeNodeId))
        .distinct(
          (a, b) => listEquals(a.segments, b.segments) && a.nodeId == b.nodeId,
        )
        .listen((record) => _updateSegments(record.segments, record.nodeId));

    _updateSource(bloc: bloc);
  }

  @override
  void didUpdateWidget(ProposalBuilderPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proposalId != oldWidget.proposalId ||
        widget.templateId != oldWidget.templateId) {
      _updateSource();
    }
  }

  @override
  void dispose() {
    unawaited(_segmentsSub?.cancel());
    _segmentsSub = null;

    _segmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SegmentsControllerScope(
      controller: _segmentsController,
      child: SpaceScaffold(
        left: const ProposalBuilderNavigationPanel(),
        body: _ProposalBuilderContent(
          controller: _segmentsScrollController,
          onRetryTap: _updateSource,
        ),
        right: const ProposalBuilderSetupPanel(),
      ),
    );
  }

  void _updateSegments(List<Segment> data, NodeId? activeSectionId) {
    final state = _segmentsController.value;

    final newState = state.segments.isEmpty
        ? SegmentsControllerState.initial(
            segments: data,
            activeSectionId: activeSectionId,
          )
        : state.copyWith(
            segments: data,
            activeSectionId: Optional(activeSectionId),
          );

    _segmentsController.value = newState;
  }

  void _handleSegmentsControllerChange() {
    final activeSectionId = _segmentsController.value.activeSectionId;

    final event = ActiveNodeChangedEvent(activeSectionId);
    context.read<ProposalBuilderBloc>().add(event);
  }

  void _updateSource({
    ProposalBuilderBloc? bloc,
  }) {
    bloc ??= context.read<ProposalBuilderBloc>();

    final proposalId = widget.proposalId;
    final templateId = widget.templateId;

    if (proposalId != null) {
      bloc.add(LoadProposalEvent(id: proposalId));
      return;
    }

    if (templateId != null) {
      bloc.add(LoadProposalTemplateEvent(id: templateId));
      return;
    }

    bloc.add(const LoadDefaultProposalTemplateEvent());
  }
}

class _ProposalBuilderContent extends StatelessWidget {
  final ItemScrollController controller;
  final VoidCallback onRetryTap;

  const _ProposalBuilderContent({
    required this.controller,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProposalBuilderErrorSelector(onRetryTap: onRetryTap),
          ProposalBuilderSegmentsSelector(itemScrollController: controller),
          const ProposalBuilderLoadingSelector(),
        ],
      ),
    );
  }
}
