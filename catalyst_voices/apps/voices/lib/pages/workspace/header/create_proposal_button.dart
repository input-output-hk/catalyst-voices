part of 'workspace_header.dart';

class _CreateProposalButton extends StatelessWidget {
  const _CreateProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () {
        unawaited(CreateNewProposalDialog.show(context));
      },
      trailing: VoicesAssets.icons.plus.buildIcon(),
      child: Text(context.l10n.createProposal),
    );
  }
}
