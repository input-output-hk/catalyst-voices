import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:flutter/material.dart';

class CoProposersConsentPageContent extends StatelessWidget {
  const CoProposersConsentPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        VoicesDrawerHeader(
          text: 'Co-Proposer Display Consent',
          onCloseTap: () => ActionsShellPage.close(context),
          showBackButton: true,
        ),
      ],
    );
  }
}
