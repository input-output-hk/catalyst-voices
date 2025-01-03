import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_rich_text_step.dart';
import 'package:catalyst_voices/widgets/navigation/sections_list_view.dart';
import 'package:catalyst_voices/widgets/navigation/sections_list_view_builder.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderBody extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const ProposalBuilderBody({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionsListViewBuilder(
      builder: (context, value, child) {
        return SectionsListView<WorkspaceSection, WorkspaceSectionStep>(
          itemScrollController: itemScrollController,
          items: value,
          stepBuilder: (context, step) {
            switch (step) {
              case RichTextStep():
                return ProposalBuilderRichTextStep(step: step);
            }
          },
        );
      },
    );
  }
}
