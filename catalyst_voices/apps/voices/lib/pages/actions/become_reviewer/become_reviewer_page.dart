import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/become_reviewer/widgets/heads_up_become_reviewer_hint_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/pages/discovery/sections/session_account_catalyst_id.dart';
import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/cards/voices_instructions_with_steps_card.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class BecomeReviewerPage extends StatelessWidget {
  const BecomeReviewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 16),
          child: VoicesDrawerHeader(
            title: Text(context.l10n.becomeReviewer),
            onCloseTap: () => ActionsShellPage.close(context),
            showBackButton: true,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              spacing: 20,
              children: [
                ActionsHeaderText(text: context.l10n.becomeReviewerActionHeaderText),
                const _Instructions(),
              ],
            ),
          ),
        ),
        const HeadsUpBecomeReviewerHintCard(),
      ],
    );
  }
}

class _CopyCatalystIdStep extends StatelessWidget {
  const _CopyCatalystIdStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SessionAccountCatalystId(
        labelText: context.l10n.copyYourCatalystId,
        labelGap: 2,
      ),
    );
  }
}

class _HeadOverToReviewModuleSteps extends StatelessWidget {
  const _HeadOverToReviewModuleSteps();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Text(
          context.l10n.headOverToReviewModule,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          context.l10n.useYourCatalystIdToRegister,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions();

  @override
  Widget build(BuildContext context) {
    return VoicesInstructionsWithStepsCard(
      title: Text(
        context.l10n.reviewerInstructions,
        style: context.textTheme.titleSmall,
      ),
      steps: const [
        InstructionStep(
          child: _CopyCatalystIdStep(),
        ),
        InstructionStep(
          suffix: _ReviewModuleButton(),
          child: _HeadOverToReviewModuleSteps(),
        ),
      ],
    );
  }
}

class _ReviewModuleButton extends StatelessWidget with LaunchUrlMixin {
  const _ReviewModuleButton();

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      child: VoicesAssets.icons.externalLink.buildIcon(),
      onTap: () {
        final shareManager = ShareManager.of(context);
        final uri = shareManager.becomeReviewer();
        unawaited(launchUri(uri));
      },
    );
  }
}
