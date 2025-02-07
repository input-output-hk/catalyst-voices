part of 'workspace_my_proposals_selector.dart';

class MyProposalsListSelector extends StatelessWidget {
  const MyProposalsListSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, MyProposalsListItems>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        return Offstage(
          offstage: state.isEmpty,
          child: MyProposalsList(items: state),
        );
      },
    );
  }
}
