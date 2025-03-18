import 'package:catalyst_voices/pages/workspace/user_proposals/user_proposals.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceUserProposalsSelector extends StatelessWidget {
  const WorkspaceUserProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, List<Proposal>>(
      selector: (state) => state.userProposals,
      builder: (context, proposals) {
        return UserProposals(
          items: proposals,
        );
      },
    );
  }
}
