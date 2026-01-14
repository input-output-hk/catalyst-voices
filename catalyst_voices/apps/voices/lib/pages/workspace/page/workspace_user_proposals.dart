import 'package:catalyst_voices/pages/workspace/user_proposals/user_proposals.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class WorkspaceUserProposals extends StatelessWidget {
  const WorkspaceUserProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.showProposals,
      builder: (context, show) {
        if (!show) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return const UserProposals();
      },
    );
  }
}
