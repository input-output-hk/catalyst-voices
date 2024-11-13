import 'package:catalyst_voices/pages/workspace/workspace_rich_text_step.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices/widgets/navigation/sections_list_view.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class WorkspaceBody extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const WorkspaceBody({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SectionsControllerScope.of(context),
      builder: (context, value, child) {
        return SectionsListView<WorkspaceSection, WorkspaceSectionStep>(
          itemScrollController: itemScrollController,
          items: value.listItems,
          stepBuilder: (context, step) {
            switch (step) {
              case RichTextStep():
                return WorkspaceRichTextStep(step: step);
            }
          },
        );
      },
    );
  }
}
