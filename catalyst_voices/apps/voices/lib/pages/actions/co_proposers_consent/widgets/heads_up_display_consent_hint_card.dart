import 'package:catalyst_voices/pages/actions/widgets/actions_hint_card.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class HeadsUpDisplayConsentHintCard extends StatelessWidget {
  const HeadsUpDisplayConsentHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionsHintCard(
      constraints: const BoxConstraints.tightFor(height: 182),
      title: context.l10n.headsUpDisplayConsentHintTitle,
      description: context.l10n.headsUpDisplayConsentHintContent,
    );
  }
}
