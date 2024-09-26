import 'package:catalyst_voices/pages/account/creation/create_keychain/create_keychain_controller.dart';
import 'package:catalyst_voices/pages/account/creation/create_keychain/create_keychain_stage.dart';
import 'package:catalyst_voices/pages/account/creation/create_keychain/stage/stages.dart';
import 'package:catalyst_voices/pages/account/creation/information_panel.dart';
import 'package:catalyst_voices/pages/account/creation/task_picture.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CreateKeychainDialog extends StatefulWidget {
  const CreateKeychainDialog._();

  static Future<String?> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      builder: (context) => const CreateKeychainDialog._(),
    );
  }

  @override
  State<CreateKeychainDialog> createState() => _CreateKeychainDialogState();
}

class _CreateKeychainDialogState extends State<CreateKeychainDialog> {
  late final CreateKeychainController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CreateKeychainController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateKeychainControllerScope(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return VoicesDesktopPanelsDialog(
            left: _CreationStatusPanel(controller: _controller),
            right: _buildStage(
              context,
              stage: _controller.stage,
            ),
          );
        },
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
  final CreateKeychainController controller;

  const _CreationStatusPanel({
    required this.controller,
  });

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
