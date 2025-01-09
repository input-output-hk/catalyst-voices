import 'dart:async';

import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_body.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_navigation_panel.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_setup_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderPage extends StatefulWidget {
  final String? proposalId;

  const ProposalBuilderPage({
    super.key,
    this.proposalId,
  });

  @override
  State<ProposalBuilderPage> createState() => _ProposalBuilderPageState();
}

class _ProposalBuilderPageState extends State<ProposalBuilderPage> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _bodyItemScrollController;

  StreamSubscription<List<Segment>>? _segmentsSub;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalBuilderBloc>();

    _segmentsController = SegmentsController();
    _bodyItemScrollController = ItemScrollController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_bodyItemScrollController);

    _segmentsSub = bloc.stream
        .map((event) => event.segments)
        .distinct(listEquals)
        .listen(_updateSegments);

    final proposalId = widget.proposalId;
    final event = proposalId != null
        ? LoadProposalEvent(id: proposalId)
        : const StartNewProposalEvent();
    bloc.add(event);
  }

  @override
  void didUpdateWidget(covariant ProposalBuilderPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proposalId != oldWidget.proposalId) {
      final proposalId = widget.proposalId;
      final event = proposalId != null
          ? LoadProposalEvent(id: proposalId)
          : const StartNewProposalEvent();
      context.read<ProposalBuilderBloc>().add(event);
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
        body: ProposalBuilderBody(
          itemScrollController: _bodyItemScrollController,
        ),
        right: const ProposalBuilderSetupPanel(),
      ),
    );
  }

  void _updateSegments(List<Segment> data) {
    final state = _segmentsController.value;

    final newState = state.segments.isEmpty
        ? SegmentsControllerState.initial(segments: data)
        : state.copyWith(segments: data);

    _segmentsController.value = newState;
  }

  void _handleSegmentsControllerChange() {
    final activeSectionId = _segmentsController.value.activeSectionId;

    final event = ActiveNodeChangedEvent(activeSectionId);
    context.read<ProposalBuilderBloc>().add(event);
  }
}
