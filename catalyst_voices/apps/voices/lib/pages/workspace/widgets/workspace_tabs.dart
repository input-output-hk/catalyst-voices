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
    return BlocSelector<WorkspaceBloc, WorkspaceState, WorkspaceStateProposalInvitesCount>(
      selector: (state) {
        return state.proposalInvitesCount;
      },
      builder: (context, count) {
        return _WorkspaceTabs(count: count, tabController: tabController);
      },
    );
  }
}

class _WorkspaceTabs extends StatelessWidget {
  final WorkspaceStateProposalInvitesCount count;

  final VoicesTabController<WorkspacePageTab> tabController;

  const _WorkspaceTabs({
    required this.count,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTabBar(
      dividerHeight: 0,
      controller: tabController,
      onTap: (tab) {
        context.read<WorkspaceBloc>().emitSignal(ChangeTabWorkspaceSignal(tab.data));
      },
      tabs: [
        for (final tab in tabController.tabs)
          VoicesTab(
            data: tab,
            key: Key(tab.name),
            child: VoicesTabText(tab.noOf(context, count: count.ofType(tab))),
          ),
      ],
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
}
