part of 'workspace_my_proposals_selector.dart';

class MyProposalsTabs extends StatelessWidget {
  final int draftProposalCount;
  final int finalProposalCount;

  const MyProposalsTabs({
    super.key,
    required this.draftProposalCount,
    required this.finalProposalCount,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: (index) {
        final tab = WorkspaceTabType.values[index];
        final event = TabChangedEvent(tab);
        context.read<WorkspaceBloc>().add(event);
      },
      tabs: [
        Tab(text: context.l10n.draftProposalsX(draftProposalCount)),
        Tab(text: context.l10n.finalProposalsX(finalProposalCount)),
      ],
    );
  }
}
