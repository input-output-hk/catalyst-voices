part of 'user_proposals_overview.dart';

class DiscoveryOverviewProposal extends StatelessWidget {
  const DiscoveryOverviewProposal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _LoadingProposalOverview(),
        _ErrorProposalOverview(),
        _DiscoveryOverviewProposalData(),
      ],
    );
  }
}

class _DiscoveryOverviewProposalData extends StatelessWidget {
  const _DiscoveryOverviewProposalData();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          BlocSelector<
            WorkspaceBloc,
            WorkspaceState,
            DataVisibilityState<List<UsersProposalOverview>>
          >(
            selector: (state) {
              return (data: state.userProposals.published.items, show: state.showProposals);
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    title: context.l10n.publishedProposals,
                  ),
                  Offstage(
                    offstage: !state.show,
                    child: _UserProposalsOverviewList(
                      proposals: state.data,
                      emptyMessage: context.l10n.noPublishedProposals,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
    );
  }
}
