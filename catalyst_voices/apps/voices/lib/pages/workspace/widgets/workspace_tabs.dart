import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceTabs extends StatelessWidget {
  final VoicesTabController<WorkspacePageTab> tabController;

  const WorkspaceTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return VoicesTabBar(
      dividerHeight: 0,
      controller: tabController,
      onTap: (tab) {
        context.read<WorkspaceCubit>().emitSignal(ChangeTabWorkspaceSignal(tab.data));
      },
      tabs: [
        for (final tab in tabController.tabs)
          VoicesTab(
            data: tab,
            key: tab.tabKey(),
            child: _TabText(key: ValueKey('${tab.name}Text'), tab: tab),
          ),
      ],
    );
  }
}

class _TabText extends StatelessWidget {
  final WorkspacePageTab tab;

  const _TabText({
    required super.key,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceCubit, WorkspaceState, int>(
      selector: (state) => state.count[tab] ?? 0,
      builder: (context, count) => VoicesTabText(tab.noOf(context, count: count)),
    );
  }
}

extension on WorkspacePageTab {
  String noOf(
    BuildContext context, {
    required int count,
  }) {
    return switch (this) {
      WorkspacePageTab.proposals => context.l10n.noOfProposals(count),
      WorkspacePageTab.proposalInvites => context.l10n.noOfProposalInvites(count),
    };
  }

  Key tabKey() {
    return switch (this) {
      WorkspacePageTab.proposals => const Key('UserProposals'),
      WorkspacePageTab.proposalInvites => const Key('ProposalInvites'),
    };
  }
}
