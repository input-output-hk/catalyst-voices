part of 'my_proposals.dart';

class WorkspaceProposalsSelector extends StatelessWidget {
  const WorkspaceProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, MyProposalsListItems>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        return Offstage(
          offstage: state.isEmpty,
          child: const MyProposals(),
        );
      },
    );
  }
}
