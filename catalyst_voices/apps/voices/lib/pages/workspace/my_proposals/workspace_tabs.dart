part of 'my_proposals.dart';

class WorkspaceTabs extends StatelessWidget {
  final int draftProposalCount;
  final int finalProposalCount;

  const WorkspaceTabs({
    super.key,
    required this.draftProposalCount,
    required this.finalProposalCount,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
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
