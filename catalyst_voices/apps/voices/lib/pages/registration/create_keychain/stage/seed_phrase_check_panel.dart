import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/seed_phrase_actions.dart';
import 'package:catalyst_voices/pages/registration/widgets/upload_seed_phrase/upload_seed_phrase_mixin.dart';
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

class _BlocSeedPhraseWords extends StatelessWidget {
  final ValueChanged<List<SeedPhraseWord>> onUserWordsChanged;

  final VoidCallback? onImportTap;
  final VoidCallback? onResetTap;

  const _BlocSeedPhraseWords({
    required this.onUserWordsChanged,
    this.onImportTap,
    this.onResetTap,
  });

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

class _SeedPhraseCheckPanelState extends State<SeedPhraseCheckPanel> with UploadSeedPhraseMixin {
  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      body: _BlocLoadable(
        builder: (context) {
          return _BlocSeedPhraseWords(
            onUserWordsChanged: _onWordsSequenceChanged,
            onImportTap: _importSeedPhrase,
            onResetTap: _clearUserWords,
          );
        },
      ),
      footer: const _BlocNavigation(),
    );
  }

  void _clearUserWords() {
    RegistrationCubit.of(context).keychainCreation.setUserSeedPhraseWords([]);
  }

  Future<void> _importSeedPhrase() async {
    final hasWords = RegistrationCubit.of(context)
        .state
        .keychainStateData
        .seedPhraseStateData
        .userWords
        .isNotEmpty;

    final words = await importSeedPhraseWords(requireConfirmation: hasWords);
    if (words == null || !mounted) {
      return;
    }

    _onWordsSequenceChanged(words);
  }

  void _onWordsSequenceChanged(List<SeedPhraseWord> words) {
    RegistrationCubit.of(context).keychainCreation.setUserSeedPhraseWords(words);
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
