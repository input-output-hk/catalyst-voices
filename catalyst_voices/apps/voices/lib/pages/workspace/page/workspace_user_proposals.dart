import 'package:catalyst_voices/pages/workspace/user_proposals/user_proposals.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceUserProposals extends StatelessWidget {
  final VoicesTabController<WorkspacePageTab> tabController;

  const WorkspaceUserProposals({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.showProposals,
      builder: (context, show) {
        if (!show) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return UserProposals(tabController: tabController);
      },
    );
  }
}
