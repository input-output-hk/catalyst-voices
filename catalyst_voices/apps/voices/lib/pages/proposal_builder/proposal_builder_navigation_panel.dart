import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_menu_placeholder.dart';
import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_segments_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBuilderNavigationPanel extends StatelessWidget {
  final bool collapsable;

  const ProposalBuilderNavigationPanel({super.key, this.collapsable = true});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      collapsable: collapsable,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: context.l10n.workspaceProposalNavigationSegments,
          body: const _MenuSelectorTab(),
        ),
      ],
    );
  }
}

class _MenuSelectorTab extends StatelessWidget {
  const _MenuSelectorTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return const DocumentBuilderMenuPlaceholder();
        } else {
          return DocumentBuilderSegmentsMenu(controller: SegmentsControllerScope.of(context));
        }
      },
    );
  }
}
