part of 'my_proposals.dart';

class MyProposalsTabSelector extends StatelessWidget {
  const MyProposalsTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.read<WorkspaceBloc>().state.tab;

    return DefaultTabController(
      length: WorkspaceTabType.values.length,
      initialIndex: tab.index,
      child: BlocListener<WorkspaceBloc, WorkspaceState>(
        listener: (context, state) {
          final index = state.tab.index;
          final tabController = DefaultTabController.of(context);

          if (tabController.index != index) {
            tabController.animateTo(index);
          }
        },
        listenWhen: (previous, current) => previous.tab != current.tab,
        child: BlocSelector<
            WorkspaceBloc,
            WorkspaceState,
            ({
              int draftProposalCount,
              int finalProposalCount,
            })>(
          selector: (state) {
            return (
              draftProposalCount: state.draftProposalCount,
              finalProposalCount: state.finalProposalCount
            );
          },
          builder: (context, state) {
            return MyProposalsTabs(
              draftProposalCount: state.draftProposalCount,
              finalProposalCount: state.finalProposalCount,
            );
          },
        ),
      ),
    );
  }
}
