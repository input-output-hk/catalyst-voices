import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/my_action_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/my_action_card_timer.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CollaboratorDisplayConsentCard extends StatelessWidget {
  const CollaboratorDisplayConsentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MyActionCard(
      key: const ValueKey(ActionsCardType.displayConsent),
      type: ActionsCardType.displayConsent,
      backgroundImagePath: VoicesAssets.images.pixelatedBallot.path,
      actionWidget: const _ActionButton(),
      timeRemainingWidget: const _Timer(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () => onTap(context),
      // TODO(LynxLynxx): add trailing
      style: FilledButton.styleFrom(
        backgroundColor: context.colorScheme.onPrimary,
        foregroundColor: context.colors.textOnPrimaryLevel0,
      ),
      child: Text(context.l10n.proposalApprovals),
    );
  }

  void onTap(BuildContext context) {
    unawaited(const CoProposersConsentRoute().push(context));
  }
}

class _Timer extends StatelessWidget {
  const _Timer();

  @override
  Widget build(BuildContext context) {
    return const MyActionCardTimer(duration: Duration(hours: 5));
  }
}
