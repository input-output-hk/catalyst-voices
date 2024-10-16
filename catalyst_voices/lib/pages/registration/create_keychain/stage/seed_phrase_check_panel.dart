import 'package:catalyst_voices/pages/registration/create_keychain/bloc_seed_phrase_builder.dart';
import 'package:catalyst_voices/pages/registration/show_upload_confirmation_dialog.dart';
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
                onUploadTap: _uploadSeedPhrase,
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

  Future<void> _uploadSeedPhrase() async {
    await showUploadConfirmationDialog(
      context,
      onUploadSuccessful: (words) {
        _onWordsSequenceChanged(words);
      },
    );
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
    return BlocSeedPhraseBuilder<bool>(
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
    this.onUploadTap,
    this.onResetTap,
  });

  final ValueChanged<List<SeedPhraseWord>> onUserWordsChanged;
  final VoidCallback? onUploadTap;
  final VoidCallback? onResetTap;

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseBuilder<
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
          onUploadTap: onUploadTap,
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
  final VoidCallback? onUploadTap;
  final VoidCallback? onResetTap;
  final bool isResetEnabled;

  const _SeedPhraseWords({
    required this.words,
    required this.userWords,
    required this.onUserWordsChanged,
    required this.onUploadTap,
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
            onUploadKeyTap: onUploadTap,
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
    return BlocSeedPhraseBuilder<bool>(
      selector: (state) => state.areUserWordsCorrect,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled: state,
        );
      },
    );
  }
}
