part of 'workspace_header.dart';

class CreateProposalButton extends StatelessWidget {
  const CreateProposalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () {
        const ProposalBuilderDraftRoute().go(context);
      },
      trailing: VoicesAssets.icons.plus.buildIcon(),
      child: Text(context.l10n.createProposal),
    );
  }
}
