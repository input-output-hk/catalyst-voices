import 'package:catalyst_voices/pages/account/creation/create_keychain/create_keychain_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SplashStagePanel extends StatelessWidget {
  const SplashStagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Create your Catalyst Keychain'),
        SizedBox(height: 24),
        Text(
          'Your keychain is your ticket to participate in  distributed innovation on the global stage.    Once you have it, you\'ll be able to enter different spaces, discover awesome ideas, and share your feedback to hep improve ideas.    As you add new keys to your keychain, you\'ll be able to enter new spaces, unlock new rewards opportunities, and have your voice heard in community decisions.',
        ),
        Spacer(),
        VoicesFilledButton(
          child: Text('Create your Keychain now'),
          onTap: () {
            CreateKeychainController.of(context).goToNextStage();
          },
        ),
      ],
    );
  }
}
