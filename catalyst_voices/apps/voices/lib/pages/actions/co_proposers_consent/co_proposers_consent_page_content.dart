import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/display_consent_list.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/heads_up_display_consent_hint_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CoProposersConsentPageContent extends StatefulWidget {
  const CoProposersConsentPageContent({super.key});

  @override
  State<CoProposersConsentPageContent> createState() => _CoProposersConsentPageContentState();
}

class _CoProposersConsentPageContentState extends State<CoProposersConsentPageContent>
    with ErrorHandlerStateMixin<DisplayConsentCubit, CoProposersConsentPageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 16),
          child: VoicesDrawerHeader(
            text: context.l10n.collaboratorDisplayConsentHeader,
            onCloseTap: () => ActionsShellPage.close(context),
            showBackButton: true,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                ActionsHeaderText(text: context.l10n.collaboratorDisplayConsentPageHeader),
                const Expanded(
                  child: CustomScrollView(
                    slivers: [
                      DisplayConsentList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const HeadsUpDisplayConsentHintCard(),
      ],
    );
  }
}
