part of 'workspace_header.dart';

class _ImportProposalButton extends StatelessWidget {
  const _ImportProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: () {
        const ProposalBuilderDraftRoute().go(context);
      },
      child: Text(context.l10n.importProposal),
    );
  }
}
