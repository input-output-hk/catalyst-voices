import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays current session action and toggling to next when clicked.
class SessionActionHeader extends StatelessWidget {
  const SessionActionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return switch (state) {
          VisitorSessionState() => const _GetStartedButton(),
          GuestSessionState() => const _UnlockButton(),
          ActiveUserSessionState() => const _LockButton(),
        };
      },
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () {
        context.read<SessionBloc>().add(const ActiveUserSessionEvent());
      },
      child: Text(context.l10n.getStarted),
    );
  }
}

class _LockButton extends StatelessWidget {
  const _LockButton();

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton.filled(
      style: const ButtonStyle(shape: WidgetStatePropertyAll(CircleBorder())),
      onTap: () {
        context.read<SessionBloc>().add(const GuestSessionEvent());
      },
      child: VoicesAssets.icons.lockClosed.buildIcon(),
    );
  }
}

class _UnlockButton extends StatelessWidget {
  const _UnlockButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      trailing: VoicesAssets.icons.lockOpen.buildIcon(),
      onTap: () {
        context.read<SessionBloc>().add(const ActiveUserSessionEvent());
      },
      child: Text(context.l10n.unlock),
    );
  }
}
