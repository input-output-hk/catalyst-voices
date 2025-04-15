import 'package:catalyst_voices/widgets/menu/voices_node_menu_placeholder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalBuilderNavigationPanel extends StatelessWidget {
  const ProposalBuilderNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: context.l10n.workspaceProposalNavigationSegments,
          body: const _MenuSelector(),
        ),
      ],
    );
  }
}

class _MenuPlaceholder extends StatelessWidget {
  const _MenuPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const VoicesNodeMenuPlaceholder(
          isExpanded: true,
          childrenCount: 2,
        ),
        for (int i = 0; i < 8; i++) const VoicesNodeMenuPlaceholder(),
      ],
    );
  }
}

class _MenuSelector extends StatelessWidget {
  const _MenuSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return const _MenuPlaceholder();
        } else {
          return SegmentsMenuListener(
            controller: SegmentsControllerScope.of(context),
          );
        }
      },
    );
  }
}
