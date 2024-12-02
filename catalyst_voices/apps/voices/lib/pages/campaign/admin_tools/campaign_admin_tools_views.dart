import 'dart:async';

import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The "views" tab of the [CampaignAdminToolsDialog].
class CampaignAdminToolsViewsTab extends StatefulWidget {
  const CampaignAdminToolsViewsTab({super.key});

  @override
  State<CampaignAdminToolsViewsTab> createState() =>
      _CampaignAdminToolsViewsTabState();
}

class _CampaignAdminToolsViewsTabState
    extends State<CampaignAdminToolsViewsTab> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.userAuthenticationState,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                return VoicesSegmentedButton<_UserAuthState>(
                  segments: [
                    for (final userState in _UserAuthState.values)
                      ButtonSegment(
                        value: userState,
                        label: Text(userState.name(context.l10n)),
                      ),
                  ],
                  selected: {_UserAuthState.fromSessionState(state)},
                  onChanged: (selected) {
                    unawaited(_switchToState(selected.first));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _switchToState(_UserAuthState state) async {
    switch (state) {
      case _UserAuthState.actor:
        await _switchToActor();
      case _UserAuthState.guest:
        await _switchToGuest();
      case _UserAuthState.visitor:
        await _switchToVisitor();
    }
  }

  Future<void> _switchToActor() async {
    final sessionBloc = context.read<SessionCubit>();
    await sessionBloc
        .switchToDummyAccount()
        .then((_) => sessionBloc.unlock(SessionCubit.dummyUnlockFactor));
  }

  Future<void> _switchToGuest() async {
    final sessionBloc = context.read<SessionCubit>();
    if (sessionBloc.state is ActiveAccountSessionState) {
      await sessionBloc.lock();
    } else if (sessionBloc.state is VisitorSessionState) {
      await sessionBloc.switchToDummyAccount().then((_) => sessionBloc.lock());
    }
  }

  Future<void> _switchToVisitor() async {
    await context.read<SessionCubit>().removeKeychain();
  }
}

enum _UserAuthState {
  actor,
  guest,
  visitor;

  factory _UserAuthState.fromSessionState(SessionState state) {
    return switch (state) {
      VisitorSessionState() => _UserAuthState.visitor,
      GuestSessionState() => _UserAuthState.guest,
      ActiveAccountSessionState() => _UserAuthState.actor,
    };
  }

  String name(VoicesLocalizations l10n) {
    return switch (this) {
      _UserAuthState.actor => l10n.actor,
      _UserAuthState.guest => l10n.guest,
      _UserAuthState.visitor => l10n.visitor,
    };
  }
}
