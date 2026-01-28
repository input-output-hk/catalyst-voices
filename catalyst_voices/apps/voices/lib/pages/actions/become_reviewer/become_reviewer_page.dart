import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/become_reviewer/widgets/heads_up_become_reviewer_hint_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
              children: [
                ActionsHeaderText(text: context.l10n.becomeReviewerActionHeaderText),
              ],
            ),
          ),
        ),
        const HeadsUpBecomeReviewerHintCard(),
      ],
    );
  }
}
