import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_error.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_loading.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_segments.dart';
import 'package:catalyst_voices/widgets/tiles/specialized/document_builder_section_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderContent extends StatelessWidget {
  final ItemScrollController itemScrollController;
  final DocumentBuilderSectionTileController sectionTileController;
  final VoidCallback onRetryTap;

  const ProposalBuilderContent({
    super.key,
    required this.itemScrollController,
    required this.sectionTileController,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProposalBuilderErrorSelector(onRetryTap: onRetryTap),
          ProposalBuilderSegmentsSelector(
            itemScrollController: itemScrollController,
            sectionTileController: sectionTileController,
          ),
          const ProposalBuilderLoadingSelector(),
        ],
      ),
    );
  }
}
