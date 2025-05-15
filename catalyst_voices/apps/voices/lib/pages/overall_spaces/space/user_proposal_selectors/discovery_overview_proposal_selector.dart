part of 'user_proposal_selectors.dart';

class DiscoveryOverviewProposalSelector extends StatelessWidget {
  const DiscoveryOverviewProposalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _LoadingProposalSelector(),
        _ErrorProposalSelector(),
        _DataProposalSelector(),
      ],
    );
  }
}

class _DataProposalSelector extends StatelessWidget {
  const _DataProposalSelector();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocSelector<WorkspaceBloc, WorkspaceState, DataVisibilityState<List<Proposal>>>(
        selector: (state) {
          return (data: state.published, show: state.showProposals);
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
                child: _DataProposalWidget(
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
