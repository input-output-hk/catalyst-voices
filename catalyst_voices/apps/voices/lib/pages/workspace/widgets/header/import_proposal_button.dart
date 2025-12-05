part of 'workspace_header.dart';

class _ImportProposalButton extends StatefulWidget {
  const _ImportProposalButton();

  @override
  State<_ImportProposalButton> createState() => _ImportProposalButtonState();
}

class _ImportProposalButtonState extends State<_ImportProposalButton> {
  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: _importProposal,
      child: Text(context.l10n.importProposal),
    );
  }

  Future<void> _importProposal() async {
    final proposal = await _ImportProposalDialog.show(context);
    if (proposal != null && mounted) {
      context.read<WorkspaceBloc>().add(ImportProposalEvent(proposal));
    }
  }
}

class _ImportProposalDialog {
  static Future<Uint8List?> show(BuildContext context) async {
    final file = await VoicesUploadFileDialog.show(
      context,
      routeSettings: const RouteSettings(name: '/import-proposal'),
      title: context.l10n.proposalImportDialogTitle,
      itemNameToUpload: context.l10n.proposal,
      info: context.l10n.proposalImportDialogDescription,
      allowedExtensions: [ProposalDocument.exportFileExt],
    );

    return await file?.readAsBytes();
  }
}
