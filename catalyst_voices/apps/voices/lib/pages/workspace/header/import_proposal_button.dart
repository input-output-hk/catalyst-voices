part of 'workspace_header.dart';

class ImportProposalButton extends StatelessWidget {
  const ImportProposalButton({super.key});

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
