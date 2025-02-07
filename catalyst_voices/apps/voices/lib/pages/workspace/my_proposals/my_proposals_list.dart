part of 'workspace_my_proposals_selector.dart';

typedef MyProposalsListItems = List<WorkspaceProposalListItem>;

class MyProposalsList extends StatelessWidget {
  final List<WorkspaceProposalListItem> items;

  const MyProposalsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = items[index];

        return ProposalListItem(
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
