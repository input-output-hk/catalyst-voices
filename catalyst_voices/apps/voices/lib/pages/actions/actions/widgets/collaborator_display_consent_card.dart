import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/my_action_card.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/my_action_card_timer.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/chips/count_indicator_chip.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CollaboratorDisplayConsentCard extends StatelessWidget {
  const CollaboratorDisplayConsentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyActionCard(
      key: ValueKey(ActionsCardType.displayConsent),
      type: ActionsCardType.displayConsent,
      actionWidget: _ActionButton(),
      timeRemainingWidget: _Timer(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () => onTap(context),
      trailing: const _TrailingIcon(),
      style: FilledButton.styleFrom(
        backgroundColor: context.colorScheme.onPrimary,
        foregroundColor: context.colors.textOnPrimaryLevel0,
      ),
      child: Text(context.l10n.proposalInvitations),
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
    return BlocSelector<MyActionsCubit, MyActionsState, Duration>(
      selector: (state) {
        return state.proposalSubmissionCloseDate?.difference(DateTimeExt.now()) ?? Duration.zero;
      },
      builder: (context, duration) {
        return MyActionCardTimer(duration: duration);
      },
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyActionsCubit, MyActionsState, int>(
      selector: (state) {
        return state.displayConsentCount;
      },
      builder: (context, count) {
        return Offstage(
          offstage: count <= 0,
          child: CountIndicatorChip(count: count),
        );
      },
    );
  }
}
