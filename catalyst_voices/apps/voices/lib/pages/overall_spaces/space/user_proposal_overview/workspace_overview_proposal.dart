part of 'user_proposals_overview.dart';

class WorkspaceOverviewProposal extends StatelessWidget {
  const WorkspaceOverviewProposal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _LoadingProposalOverview(),
        _ErrorProposalOverview(),
        _WorkspaceDataProposalOverview(),
      ],
    );
  }
}

class _WorkspaceDataProposalOverview extends StatelessWidget {
  const _WorkspaceDataProposalOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(title: context.l10n.notPublishedProposals),
        BlocSelector<WorkspaceBloc, WorkspaceState, DataVisibilityState<UserProposalsView>>(
          selector: (state) {
            return (
              data: state.userProposals.notPublished,
              show: state.showProposals && !state.isLoading,
            );
          },
          builder: (context, state) {
            return Offstage(
              offstage: !state.show,
              child: _UserProposalsOverviewList(
                proposals: state.data.items,
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
