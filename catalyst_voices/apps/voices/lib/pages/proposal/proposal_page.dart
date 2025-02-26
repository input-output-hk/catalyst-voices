import 'dart:async';

import 'package:catalyst_voices/pages/proposal/proposal_content.dart';
import 'package:catalyst_voices/pages/proposal/proposal_navigation_panel.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalPage extends StatefulWidget {
  final String id;
  final String? version;
  final bool isDraft;

  const ProposalPage({
    super.key,
    required this.id,
    this.version,
    required this.isDraft,
  });

  DocumentRef get ref {
    return DocumentRef.build(
      id: id,
      version: version,
      isDraft: isDraft,
    );
  }

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _segmentsScrollController;

  StreamSubscription<dynamic>? _segmentsSub;

  @override
  Widget build(BuildContext context) {
    return SegmentsControllerScope(
      controller: _segmentsController,
      child: Scaffold(
        appBar: const VoicesAppBar(),
        body: SpaceScaffold(
          left: const ProposalNavigationPanel(),
          body: ProposalContent(scrollController: _segmentsScrollController),
          right: const Offstage(),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ProposalPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ref != oldWidget.ref) {
      context.read<ProposalBloc>().add(ShowProposalEvent(ref: widget.ref));
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
  void initState() {
    super.initState();

    final bloc = context.read<ProposalBloc>();

    _segmentsController = SegmentsController();
    _segmentsScrollController = ItemScrollController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_segmentsScrollController);

    _segmentsSub = bloc.stream
        .map((event) {
          return (
            segments: event.data.segments,
            nodeId: event.data.activeNodeId,
          );
        })
        .distinct(
          (a, b) => listEquals(a.segments, b.segments) && a.nodeId == b.nodeId,
        )
        .listen((record) => _updateSegments(record.segments, record.nodeId));

    bloc.add(ShowProposalEvent(ref: widget.ref));
  }

  void _changeVersion(String version) {
    Router.neglect(context, () {
      final ref = widget.ref.copyWith(version: Optional.of(version));
      ProposalRoute.from(ref: ref).replace(context);
    });
  }

  void _handleSegmentsControllerChange() {}

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
}
