import 'dart:async';

import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/seed_phrase_actions.dart';
import 'package:catalyst_voices/pages/registration/widgets/upload_seed_phrase/upload_seed_phrase_mixin.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseInputPanel extends StatefulWidget {
  const SeedPhraseInputPanel({super.key});

  @override
  State<SeedPhraseInputPanel> createState() => _SeedPhraseInputPanelState();
}

class _BlocNavigation extends StatelessWidget {
  final VoidCallback onNextTap;

  const _BlocNavigation({
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRecoverSelector(
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

class _BlocSeedPhraseField extends StatelessWidget {
  final SeedPhraseFieldController controller;
  final FocusNode focusNode;

  const _BlocSeedPhraseField({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRecoverSelector<List<String>>(
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

class _SeedPhraseInputPanelState extends State<SeedPhraseInputPanel>
    with UploadSeedPhraseMixin {
  late final SeedPhraseFieldController _controller;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: Text(
            context.l10n.recoverySeedPhraseInputTitle,
            key: const Key('RecoverySeedPhraseInputTitle'),
          ),
          subtitle: Text(
            context.l10n.recoverySeedPhraseInputSubtitle,
            key: const Key('RecoverySeedPhraseInputSubtitle'),
          ),
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
          onImportKeyTap: _uploadSeedPhrase,
          onResetTap: _resetControllerWords,
        ),
        const SizedBox(height: 12),
        _BlocNavigation(
          onNextTap: _recoverAccountAndGoNextStage,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final recoverState = RegistrationCubit.of(context).state.recoverStateData;
    final words = recoverState.userSeedPhraseWords;

    _controller = SeedPhraseFieldController(words)
      ..addListener(_onWordsChanged);
  }

  void _onWordsChanged() {
    final words = [..._controller.value];

    RegistrationCubit.of(context).recover.setSeedPhraseWords(words);
  }

  void _recoverAccountAndGoNextStage() {
    final registration = RegistrationCubit.of(context);

    // Note. success or failure will be shown in next stage
    unawaited(registration.recover.recoverAccount());

    registration.nextStep();
  }

  void _resetControllerWords() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  Future<void> _uploadSeedPhrase() async {
    final hasWords = _controller.words.isNotEmpty;
    final words = await importSeedPhraseWords(requireConfirmation: hasWords);
    if (words == null || !mounted) {
      return;
    }

    _controller.words = words;
  }
}
