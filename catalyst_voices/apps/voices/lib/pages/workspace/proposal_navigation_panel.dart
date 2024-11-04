import 'package:catalyst_voices/pages/workspace/proposal_segment_controller.dart';
import 'package:catalyst_voices/pages/workspace/workspace_proposal_navigation_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalNavigationPanel extends StatelessWidget {
  final WorkspaceProposalNavigation navigation;

  const ProposalNavigationPanel({
    super.key,
    required this.navigation,
  });

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: context.l10n.workspaceProposalNavigation,
      onCollapseTap: () {},
      tabs: [
        if (navigation.segments.isNotEmpty)
          SpaceSidePanelTab(
            name: context.l10n.workspaceProposalNavigationSegments,
            body: Column(
              children: navigation.segments.map(
                (segment) {
                  return _ProposalSegmentBody(
                    key: ValueKey('ProposalSegment${segment.id}Key'),
                    segment: segment,
                    controller: ProposalControllerScope.of(
                      context,
                      id: segment.id,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
      ],
    );
  }
}

class _ProposalSegmentBody extends StatelessWidget {
  final WorkspaceProposalSegment segment;
  final VoicesNodeMenuController? controller;

  const _ProposalSegmentBody({
    super.key,
    required this.segment,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesNodeMenu(
      name: segment.localizedName(l10n),
      controller: controller,
      items: segment.steps.map(
        (step) {
          return VoicesNodeMenuItem(
            id: step.id,
            label: step.title,
          );
        },
      ).toList(),
    );
  }
}
