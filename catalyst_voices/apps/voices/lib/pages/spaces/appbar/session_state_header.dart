import 'dart:async';

import 'package:catalyst_voices/pages/spaces/appbar/session_account_popup_menu.dart';
import 'package:catalyst_voices/routes/routing/account_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays current session state.
class SessionStateHeader extends StatelessWidget {
  const SessionStateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return switch (state) {
          VisitorSessionState() => const SessionAccountPopupMenu(),
          GuestSessionState() => const SessionAccountPopupMenu(),
          ActiveAccountSessionState() => const SessionAccountPopupMenu(),
        };
      },
    );
  }

  void _onLockAccount(BuildContext context) {
    unawaited(context.read<SessionCubit>().lock());
  }

  void _onSeeProfile(BuildContext context) {
    unawaited(
      const AccountRoute().push<void>(context),
    );
  }
}

class _GuestButton extends StatelessWidget {
  const _GuestButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      child: Text(context.l10n.guest),
      onTap: () {},
    );
  }
}

class _VisitorButton extends StatelessWidget {
  const _VisitorButton();

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      child: Text(context.l10n.visitor),
      onTap: () {},
    );
  }
}
