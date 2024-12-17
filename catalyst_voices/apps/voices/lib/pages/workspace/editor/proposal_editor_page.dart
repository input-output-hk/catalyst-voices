import 'dart:async';

import 'package:catalyst_voices/pages/workspace/editor/proposal_body.dart';
import 'package:catalyst_voices/pages/workspace/editor/proposal_editor_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/editor/proposal_editor_setup_panel.dart';
import 'package:catalyst_voices/widgets/containers/space_scaffold.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalEditorPage extends StatefulWidget {
  final String proposalId;

  const ProposalEditorPage({
    super.key,
    required this.proposalId,
  });

  @override
  State<ProposalEditorPage> createState() => _ProposalEditorPageState();
}

class _ProposalEditorPageState extends State<ProposalEditorPage> {
  late final SectionsController _sectionsController;
  late final ItemScrollController _bodyItemScrollController;

  SectionStepId? _activeStepId;
  StreamSubscription<List<Section>>? _sectionsSub;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalEditorBloc>();

    _sectionsController = SectionsController();
    _bodyItemScrollController = ItemScrollController();

    _sectionsController
      ..addListener(_handleSectionsControllerChange)
      ..attachItemsScrollController(_bodyItemScrollController);

    _sectionsSub = bloc.stream
        .map((event) => event.sections)
        .distinct(listEquals)
        .listen(_updateSections);

    bloc.add(LoadProposalEvent(id: widget.proposalId));
  }

  @override
  void didUpdateWidget(covariant ProposalEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proposalId != oldWidget.proposalId) {
      final event = LoadProposalEvent(id: widget.proposalId);
      context.read<ProposalEditorBloc>().add(event);
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
        left: const ProposalEditorNavigationPanel(),
        body: ProposalBody(
          itemScrollController: _bodyItemScrollController,
        ),
        right: const ProposalEditorSetupPanel(),
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
      context.read<ProposalEditorBloc>().add(event);
    }
  }
}
