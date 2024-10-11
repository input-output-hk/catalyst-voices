import 'dart:async';

import 'package:catalyst_voices/pages/registration/recover/bloc_recover_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/seed_phrase_actions.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseInputPanel extends StatefulWidget {
  const SeedPhraseInputPanel({super.key});

  @override
  State<SeedPhraseInputPanel> createState() => _SeedPhraseInputPanelState();
}

class _SeedPhraseInputPanelState extends State<SeedPhraseInputPanel> {
  late final SeedPhraseFieldController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final recoverState = RegistrationCubit.of(context).state.recoverStateData;
    final words = recoverState.userSeedPhraseWords;

    _controller = SeedPhraseFieldController(words)
      ..addListener(_onWordsChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: Text(context.l10n.recoverySeedPhraseInputTitle),
          subtitle: Text(context.l10n.recoverySeedPhraseInputSubtitle),
          spacing: 12,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _BlocSeedPhraseField(
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
        const SizedBox(height: 12),
        SeedPhraseActions(
          onUploadKeyTap: _uploadSeedPhrase,
          onResetTap: _resetControllerWords,
        ),
        const SizedBox(height: 12),
        _BlocNavigation(
          onNextTap: _recoverAccountAndGoNextStage,
        ),
      ],
    );
  }

  void _recoverAccountAndGoNextStage() {
    final registration = RegistrationCubit.of(context);

    // Note. success or failure will be shown in next stage
    unawaited(registration.recover.recoverAccount());

    registration.nextStep();
  }

  Future<void> _uploadSeedPhrase() async {
    // TODO(damian-molinski): Import implementation for KeychainCreation
  }

  void _resetControllerWords() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _onWordsChanged() {
    final words = [..._controller.value];

    RegistrationCubit.of(context).recover.setSeedPhraseWords(words);
  }
}

class _BlocSeedPhraseField extends StatelessWidget {
  final SeedPhraseFieldController controller;
  final FocusNode focusNode;

  const _BlocSeedPhraseField({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRecoverBuilder<List<String>>(
      selector: (state) => state.seedPhraseWords,
      builder: (context, state) {
        return SeedPhraseField(
          controller: controller,
          focusNode: focusNode,
          wordList: state,
        );
      },
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  final VoidCallback onNextTap;

  const _BlocNavigation({
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRecoverBuilder(
      selector: (state) => state.isSeedPhraseValid,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          onNextTap: onNextTap,
          isNextEnabled: state,
        );
      },
    );
  }
}
