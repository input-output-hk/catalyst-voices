part of 'workspace_my_proposals_selector.dart';

class _MyProposalsListSelector extends StatelessWidget {
  const _MyProposalsListSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, MyProposalsListItems>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        return Offstage(
          offstage: state.isEmpty,
          child: _MyProposalsList(items: state),
        );
      },
    );
  }
}
