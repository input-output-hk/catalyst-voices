import 'package:catalyst_voices/pages/workspace/workspace_body.dart';
import 'package:catalyst_voices/pages/workspace/workspace_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/workspace_setup_panel.dart';
import 'package:catalyst_voices/widgets/containers/space_scaffold.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({
    super.key,
  });

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  late final SectionsController _sectionsController;
  late final ItemScrollController _bodyItemScrollController;

  @override
  void initState() {
    super.initState();

    _sectionsController = SectionsController();
    _bodyItemScrollController = ItemScrollController();

    _sectionsController.attachItemsScrollController(_bodyItemScrollController);
  }

  @override
  void dispose() {
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
}
