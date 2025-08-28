import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_popup_menu.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Displays account settings dropdown button.
class AccountSettingsAction extends StatelessWidget {
  const AccountSettingsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) => switch (state.status) {
        SessionStatus.visitor || SessionStatus.guest => true,
        SessionStatus.actor => false,
      },
      builder: (context, offstage) {
        return Offstage(
          offstage: offstage,
          child: const SessionAccountPopupMenu(),
        );
      },
    );
  }
}
