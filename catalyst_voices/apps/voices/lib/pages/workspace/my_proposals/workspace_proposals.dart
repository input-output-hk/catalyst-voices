part of 'my_proposals.dart';

typedef ListItems = List<WorkspaceProposalListItem>;

class WorkspaceProposals extends StatelessWidget {
  final List<WorkspaceProposalListItem> items;

  const WorkspaceProposals({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = items[index];

        return ProposalListTile(
          key: ValueKey('WorkspaceProposal${item.id}ListTileKey'),
          item: item,
          onTap: () {
            ProposalBuilderRoute(proposalId: item.id).go(context);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: items.length,
      padding: const EdgeInsets.all(32),
    );
  }
}

class WorkspaceProposalsSelector extends StatelessWidget {
  const WorkspaceProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, ListItems>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        return Offstage(
          offstage: state.isEmpty,
          child: WorkspaceProposals(items: state),
        );
      },
    );
  }
}
