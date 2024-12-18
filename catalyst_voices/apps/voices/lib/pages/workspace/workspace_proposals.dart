import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceProposals extends StatelessWidget {
  const WorkspaceProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: true,
      child: ListView.separated(
        itemBuilder: (context, index) {
          final item = WorkspaceProposalListItem(id: '$index', name: '$index');
          return _ProposalListTile(
            key: ValueKey('WorkspaceProposal${item.id}ListTileKey'),
            item: item,
            onTap: () {
              ProposalEditorRoute(proposalId: item.id).go(context);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: 20,
        padding: const EdgeInsets.all(32),
      ),
    );
  }
}

class _ProposalListTile extends StatelessWidget {
  final WorkspaceProposalListItem item;
  final VoidCallback? onTap;

  const _ProposalListTile({
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
