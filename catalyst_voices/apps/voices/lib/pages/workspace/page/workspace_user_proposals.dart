import 'package:catalyst_voices/pages/workspace/user_proposals/user_proposals.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef UserProposalsSelectorState = ({bool show, List<Proposal> proposals});

class WorkspaceUserProposalsSelector extends StatelessWidget {
  const WorkspaceUserProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState,
        UserProposalsSelectorState>(
      selector: (state) => (
        proposals: state.userProposals,
        show: state.showProposals,
      ),
      builder: (context, state) {
        return Offstage(
          offstage: !state.show,
          child: UserProposals(
            items: state.proposals,
          ),
        );
      },
    );
  }
}
