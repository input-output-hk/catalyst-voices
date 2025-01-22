import 'package:catalyst_voices/pages/registration/incorrect_seed_phrase_dialog.dart';
import 'package:catalyst_voices/pages/registration/upload_seed_phrase_confirmation_dialog.dart';
import 'package:catalyst_voices/pages/registration/upload_seed_phrase_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/seed_phrase_actions.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SeedPhraseCheckPanel extends StatefulWidget {
  const SeedPhraseCheckPanel({
    super.key,
  });

  @override
  State<SeedPhraseCheckPanel> createState() => _SeedPhraseCheckPanelState();
}

class _SeedPhraseCheckPanelState extends State<SeedPhraseCheckPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _BlocLoadable(
            builder: (context) {
              return _BlocSeedPhraseWords(
                onUserWordsChanged: _onWordsSequenceChanged,
                onImportTap: _importSeedPhrase,
                onResetTap: _clearUserWords,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        const _BlocNavigation(),
      ],
    );
  }

  Future<void> _importSeedPhrase() async {
    final showUpload = await UploadSeedPhraseConfirmationDialog.show(context);
    if (showUpload) {
      await _showUploadDialog();
    }
  }

  Future<void> _showUploadDialog() async {
    final words = await UploadSeedPhraseDialog.show(context);

    if (!mounted) return;

    final areWordsMatching =
        RegistrationCubit.of(context).keychainCreation.areWordsMatching(words);

    final isValid = areWordsMatching &&
        SeedPhrase.isValid(
          words: words,
        );

    if (isValid) {
      _onWordsSequenceChanged(words);
    } else {
      final showUpload = await IncorrectSeedPhraseDialog.show(context);
      if (showUpload) {
        await _showUploadDialog();
      }
    }
  }

  void _clearUserWords() {
    RegistrationCubit.of(context).keychainCreation.setUserSeedPhraseWords([]);
  }

  void _onWordsSequenceChanged(List<SeedPhraseWord> words) {
    RegistrationCubit.of(context)
        .keychainCreation
        .setUserSeedPhraseWords(words);
  }
}

class _BlocLoadable extends StatelessWidget {
  final WidgetBuilder builder;

  const _BlocLoadable({
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return VoicesLoadable(
          isLoading: state,
          builder: builder,
        );
      },
    );
  }
}

class _BlocSeedPhraseWords extends StatelessWidget {
  const _BlocSeedPhraseWords({
    required this.onUserWordsChanged,
    this.onImportTap,
    this.onResetTap,
  });

  final ValueChanged<List<SeedPhraseWord>> onUserWordsChanged;
  final VoidCallback? onImportTap;
  final VoidCallback? onResetTap;

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<
        ({
          List<SeedPhraseWord> shuffledWords,
          List<SeedPhraseWord> words,
          bool isResetWordsEnabled,
        })>(
      selector: (state) => (
        shuffledWords: state.shuffledWords,
        words: state.userWords,
        isResetWordsEnabled: state.isResetWordsEnabled,
      ),
      builder: (context, state) {
        return _SeedPhraseWords(
          words: state.shuffledWords,
          userWords: state.words,
          onUserWordsChanged: onUserWordsChanged,
          onImportTap: onImportTap,
          onResetTap: onResetTap,
          isResetEnabled: state.isResetWordsEnabled,
        );
      },
    );
  }
}

class _SeedPhraseWords extends StatelessWidget {
  final List<SeedPhraseWord> words;
  final List<SeedPhraseWord> userWords;
  final ValueChanged<List<SeedPhraseWord>> onUserWordsChanged;
  final VoidCallback? onImportTap;
  final VoidCallback? onResetTap;
  final bool isResetEnabled;

  const _SeedPhraseWords({
    required this.words,
    required this.userWords,
    required this.onUserWordsChanged,
    required this.onImportTap,
    required this.onResetTap,
    required this.isResetEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          SeedPhrasesSequencer(
            words: words,
            selectedWords: userWords,
            onChanged: onUserWordsChanged,
          ),
          const SizedBox(height: 10),
          SeedPhraseActions(
            onImportKeyTap: onImportTap,
            onResetTap: isResetEnabled ? onResetTap : null,
          ),
        ],
      ),
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.areUserWordsCorrect,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled: state,
        );
      },
    );
  }
}
