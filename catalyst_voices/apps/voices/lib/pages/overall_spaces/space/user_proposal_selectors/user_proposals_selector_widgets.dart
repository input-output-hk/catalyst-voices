part of 'user_proposal_selectors.dart';

class _DataProposalWidget extends StatelessWidget {
  final List<Proposal> proposals;
  final String emptyMessage;
  final bool showLatestLocal;

  const _DataProposalWidget({
    required this.proposals,
    required this.emptyMessage,
    this.showLatestLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (proposals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          emptyMessage,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      );
    }
    return Column(
      spacing: 12,
      children: proposals
          .map(
            (e) => SmallProposalCard(
              proposal: e,
              showLatestLocal: showLatestLocal,
            ),
          )
          .toList(),
    );
  }
}

class _ErrorProposalSelector extends StatelessWidget {
  const _ErrorProposalSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, VisibilityState>(
      selector: (state) {
        return (error: state.error, show: state.showError);
      },
      builder: (context, state) {
        return Offstage(
          offstage: !state.show,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: VoicesErrorIndicator(
              message: state.error?.message(context) ??
                  const LocalizedUnknownException().message(context),
              onRetry: () => context
                  .read<WorkspaceBloc>()
                  .add(const WatchUserProposalsEvent()),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        top: 18,
        bottom: 18,
      ),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
    );
  }
}

class _LoadingProposalSelector extends StatelessWidget {
  const _LoadingProposalSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, isLoading) => Offstage(
        offstage: !isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Center(
            child: TickerMode(
              enabled: isLoading,
              child: const VoicesCircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
