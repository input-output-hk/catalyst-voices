import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/representative/widgets/heads_up_representative_hint_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class RepresentativeActionPage extends StatelessWidget {
  const RepresentativeActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 16),
          child: VoicesDrawerHeader(
            title: Text(context.l10n.becomeARepresentative),
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
              ],
            ),
          ),
        ),
        const HeadsUpRepresentativeHintCard(),
      ],
    );
  }
}
