part of 'my_proposals.dart';

class ProposalListTile extends StatelessWidget {
  final WorkspaceProposalListItem item;
  final VoidCallback? onTap;

  const ProposalListTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Text(item.name),
        ),
      ),
    );
  }
}
