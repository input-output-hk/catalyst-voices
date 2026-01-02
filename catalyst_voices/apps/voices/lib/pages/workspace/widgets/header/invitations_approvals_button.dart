import 'dart:async' show unawaited;

import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/chips/count_indicator_chip.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InvitationsApprovalsButton extends StatelessWidget {
  const InvitationsApprovalsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, int>(
      selector: (state) {
        return state.invitationsApprovalsCount;
      },
      builder: (context, count) {
        return _InvitationsApprovalsButton(count: count);
      },
    );
  }
}

class _InvitationsApprovalsButton extends StatelessWidget {
  final int count;

  const _InvitationsApprovalsButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      trailing: count != 0 ? CountIndicatorChip(count: count) : null,
      onTap: () => _onTap(context),
      child: Text(context.l10n.invitationsAndApprovals),
    );
  }

  void _onTap(BuildContext context) {
    unawaited(const ActionsRoute().push(context));
  }
}
