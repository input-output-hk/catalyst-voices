import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalCommentPickUsernameTile extends StatelessWidget {
  const ProposalCommentPickUsernameTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _LabelText(),
        const SizedBox(height: 12),
        _PickUsernameButton(onTap: () => _showUsernameDialog(context)),
      ],
    );
  }

  void _showUsernameDialog(BuildContext context) {
    // TODO(damian-molinski): Finish implementation when
    //  we know how it should look.

    throw UnimplementedError();
  }
}

class _LabelText extends StatelessWidget {
  const _LabelText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.commentPickUsernameLabel,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}

class _PickUsernameButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _PickUsernameButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: Text(context.l10n.commentPickUsernameButton),
    );
  }
}
