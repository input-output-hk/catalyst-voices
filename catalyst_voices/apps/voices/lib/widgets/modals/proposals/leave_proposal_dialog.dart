import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

class LeaveProposalDialog extends StatefulWidget {
  const LeaveProposalDialog({super.key});

  @override
  State<LeaveProposalDialog> createState() => _LeaveProposalDialogState();

  static Future<bool> show({
    required BuildContext context,
  }) async {
    return await VoicesDialog.show<bool>(
          context: context,
          builder: (context) => const LeaveProposalDialog(),
          routeSettings: const RouteSettings(name: '/leave-proposal-dialog'),
        ) ??
        false;
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      child: Text(context.l10n.leaveProposal),
      onTap: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    Navigator.pop(context, true);
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.leaveProposalDescription,
      textAlign: TextAlign.center,
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return VoicesAssets.icons.unlink.buildIcon(
      color: context.colors.iconsError,
      size: 45,
    );
  }
}

class _LeaveProposalDialogState extends State<LeaveProposalDialog> {
  @override
  Widget build(BuildContext context) {
    return const VoicesPanelDialog(
      constraints: Responsive.single(
        BoxConstraints(maxWidth: 511, maxHeight: 285),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 36, 16, 20),
        child: Column(
          children: [
            _Icon(),
            SizedBox(height: 6),
            _Title(),
            SizedBox(height: 20),
            _Description(),
            Spacer(),
            _ActionButton(),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.leaveProposalQuestion,
      style: context.textTheme.titleLarge,
    );
  }
}
