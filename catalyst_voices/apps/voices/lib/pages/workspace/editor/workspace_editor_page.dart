import 'dart:async';

import 'package:catalyst_voices/pages/workspace/editor/workspace_body.dart';
import 'package:catalyst_voices/pages/workspace/editor/workspace_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/editor/workspace_setup_panel.dart';
import 'package:catalyst_voices/widgets/containers/space_scaffold.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class WorkspaceEditorPage extends StatefulWidget {
  final String proposalId;

  const WorkspaceEditorPage({
    super.key,
    required this.proposalId,
  });

  @override
  State<WorkspaceEditorPage> createState() => _WorkspaceEditorPageState();
}

class _WorkspaceEditorPageState extends State<WorkspaceEditorPage> {
  late final SectionsController _sectionsController;
  late final ItemScrollController _bodyItemScrollController;

  SectionStepId? _activeStepId;
  StreamSubscription<List<Section>>? _sectionsSub;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<WorkspaceEditorBloc>();

    _sectionsController = SectionsController();
    _bodyItemScrollController = ItemScrollController();

    _sectionsController
      ..addListener(_handleSectionsControllerChange)
      ..attachItemsScrollController(_bodyItemScrollController);

    _sectionsSub = bloc.stream
        .map((event) => event.sections)
        .distinct(listEquals)
        .listen(_updateSections);

    print('Initializing with proposalId[${widget.proposalId}]');

    bloc.add(LoadProposalEvent(id: widget.proposalId));
  }

  @override
  void didUpdateWidget(covariant WorkspaceEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proposalId != oldWidget.proposalId) {
      print(
        'Changing proposalId from[${oldWidget.proposalId}] '
        'to [${widget.proposalId}]',
      );
      final event = LoadProposalEvent(id: widget.proposalId);
      context.read<WorkspaceEditorBloc>().add(event);
    }
  }

  @override
  void dispose() {
    unawaited(_sectionsSub?.cancel());
    _sectionsSub = null;

    _sectionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionsControllerScope(
      controller: _sectionsController,
      child: SpaceScaffold(
        left: const WorkspaceNavigationPanel(),
        body: WorkspaceBody(
          itemScrollController: _bodyItemScrollController,
        ),
        right: const WorkspaceSetupPanel(),
      ),
    );
  }

  void _updateSections(List<Section> data) {
    final state = _sectionsController.value;

    final newState = state.sections.isEmpty
        ? SectionsControllerState.initial(sections: data)
        : state.copyWith(sections: data);

    _sectionsController.value = newState;
  }

  void _handleSectionsControllerChange() {
    final activeStepId = _sectionsController.value.activeStepId;

    if (_activeStepId != activeStepId) {
      _activeStepId = activeStepId;

      final event = ActiveStepChangedEvent(activeStepId);
      context.read<WorkspaceEditorBloc>().add(event);
    }
  }
}
