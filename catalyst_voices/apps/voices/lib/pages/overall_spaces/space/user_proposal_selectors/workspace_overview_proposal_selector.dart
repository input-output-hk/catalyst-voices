part of 'user_proposal_selectors.dart';

class WorkspaceOverviewProposalSelector extends StatelessWidget {
  const WorkspaceOverviewProposalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _LoadingProposalSelector(),
        _ErrorProposalSelector(),
        _WorkspaceDataProposalSelector(),
      ],
    );
  }
}

class _WorkspaceDataProposalSelector extends StatelessWidget {
  const _WorkspaceDataProposalSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(title: context.l10n.notPublishedProposals),
        BlocSelector<WorkspaceBloc, WorkspaceState, DataVisibilityState<List<Proposal>>>(
          selector: (state) {
            return (data: state.notPublished, show: state.showProposals && !state.isLoading);
          },
          builder: (context, state) {
            return Offstage(
              offstage: !state.show,
              child: _DataProposalWidget(
                proposals: state.data,
                emptyMessage: context.l10n.noProposalsToPublish,
                showLatestLocal: true,
              ),
            );
          },
        ),
      ],
    );
  }
}
