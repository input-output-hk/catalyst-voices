import 'package:catalyst_voices/pages/account/setup/create_keychain/create_keychain_stage.dart';
import 'package:catalyst_voices/pages/account/setup/create_keychain/stage/stages.dart';
import 'package:catalyst_voices/pages/account/setup/information_panel.dart';
import 'package:catalyst_voices/pages/account/setup/task_picture.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CreateKeychainDialog extends StatefulWidget {
  const CreateKeychainDialog({super.key});

  @override
  State<CreateKeychainDialog> createState() => _CreateKeychainDialogState();
}

class _CreateKeychainDialogState extends State<CreateKeychainDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopPanelsDialog(
      left: const _CreationStatusPanel(),
      right: _buildStage(
        context,
        stage: CreateKeychainStage.splash,
      ),
    );
  }

  Widget _buildStage(
    BuildContext context, {
    required CreateKeychainStage stage,
  }) {
    return switch (stage) {
      CreateKeychainStage.splash => const SplashPanel(),
      CreateKeychainStage.instructions => const InstructionsPanel(),
      CreateKeychainStage.seedPhrase ||
      CreateKeychainStage.checkSeedPhraseInstructions ||
      CreateKeychainStage.checkSeedPhrase ||
      CreateKeychainStage.checkSeedPhraseResult ||
      CreateKeychainStage.unlockPasswordInstructions ||
      CreateKeychainStage.unlockPasswordCreate ||
      CreateKeychainStage.created =>
        const Placeholder(),
    };
  }
}

class _CreationStatusPanel extends StatelessWidget {
  const _CreationStatusPanel();

  @override
  Widget build(BuildContext context) {
    return InformationPanel(
      title: context.l10n.catalystKeychain,
      subtitle: 'Write down your 12 Catalyst  security words',
      body: 'Make sure you create an offline backup '
          'of your recovery phrase as well.',
      picture: const TaskKeychainPicture(),
      progress: 0.2,
    );
  }
}
