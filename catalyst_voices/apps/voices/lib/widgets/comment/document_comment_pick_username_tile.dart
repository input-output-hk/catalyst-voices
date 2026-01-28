import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/comment/pick_username_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentCommentPickUsernameTile extends StatelessWidget {
  final ValueChanged<String> onUsernamePicked;

  const DocumentCommentPickUsernameTile({
    super.key,
    required this.onUsernamePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _LabelText(),
        const SizedBox(height: 12),
        _PickUsernameButton(
          onTap: () => unawaited(_showUsernameDialog(context)),
        ),
      ],
    );
  }

  Future<void> _showUsernameDialog(BuildContext context) async {
    final username = await PickUsernameDialog.show(context);
    if (username == null || !context.mounted) {
      return;
    }

    onUsernamePicked(username);
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
      child: Text(context.l10n.commentPickUsername),
    );
  }
}
