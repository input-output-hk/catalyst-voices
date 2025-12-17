import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InvitationsApprovalsButton extends StatelessWidget {
  const InvitationsApprovalsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InvitationsApprovalsButton(count: 10);
  }
}

class _CountIndicator extends StatelessWidget {
  final int count;

  const _CountIndicator({required this.count});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.round(
      backgroundColor: context.colorScheme.error,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      content: Text(
        count.toString(),
        style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onError),
      ),
    );
  }
}

class _InvitationsApprovalsButton extends StatelessWidget {
  final int count;

  const _InvitationsApprovalsButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      trailing: count != 0 ? _CountIndicator(count: count) : null,
      onTap: () {
        // TODO(LynxLynxx): Call to open action drawer.
      },
      child: Text(context.l10n.invitationsAndApprovals),
    );
  }
}
