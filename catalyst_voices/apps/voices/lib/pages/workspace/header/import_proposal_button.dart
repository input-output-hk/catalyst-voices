part of 'workspace_header.dart';

class _ImportProposalButton extends StatelessWidget {
  const _ImportProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: () {
        unawaited(const ProposalBuilderDraftRoute().push(context));
      },
      child: Text(context.l10n.importProposal),
    );
  }
}
