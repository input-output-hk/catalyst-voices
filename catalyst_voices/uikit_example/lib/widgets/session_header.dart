import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays current session state and a button to toggle it to a next state.
class SessionHeader extends StatelessWidget {
  const SessionHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return switch (state) {
          VisitorSessionState() => const _VisitorSessionHeader(),
          GuestSessionState() => const _GuestSessionHeader(),
          ActiveUserSessionState() => const _ActiveUserSessionHeader(),
        };
      },
    );
  }
}

class _VisitorSessionHeader extends StatelessWidget {
  const _VisitorSessionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          child: Text('Get Started'),
          onTap: () =>
              context.read<SessionBloc>().add(const NextStateSessionEvent()),
        ),
        const SizedBox(width: 12),
        VoicesFilledButton(
          child: Text('Visitor'),
        ),
      ],
    );
  }
}

class _GuestSessionHeader extends StatelessWidget {
  const _GuestSessionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          trailing: Icon(CatalystVoicesIcons.lock_open),
          child: Text('Unlock'),
          onTap: () =>
              context.read<SessionBloc>().add(const NextStateSessionEvent()),
        ),
        const SizedBox(width: 12),
        VoicesFilledButton(
          child: Text('Guest'),
        ),
      ],
    );
  }
}

class _ActiveUserSessionHeader extends StatelessWidget {
  const _ActiveUserSessionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          trailing: Icon(CatalystVoicesIcons.lock_closed),
          child: Text('Lock'),
          onTap: () =>
              context.read<SessionBloc>().add(const NextStateSessionEvent()),
        ),
        const SizedBox(width: 12),
        VoicesFilledButton(
          child: Text('John Smith'),
        ),
      ],
    );
  }
}
