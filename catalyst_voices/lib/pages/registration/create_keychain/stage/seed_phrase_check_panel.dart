import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // TODO(damian-molinski): open upload dialog
  }

  void _clearUserWords() {
    RegistrationCubit.of(context).keychainCreation.setUserSeedPhraseWords([]);
  }

  void _onWordsSequenceChanged(List<String> words) {
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
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        return previous.keychainStateData.seedPhraseStateData.isLoading !=
            current.keychainStateData.seedPhraseStateData.isLoading;
      },
      builder: (context, state) {
        return VoicesLoadable(
          isLoading: state.keychainStateData.seedPhraseStateData.isLoading,
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

  final ValueChanged<List<String>> onUserWordsChanged;
  final VoidCallback? onUploadTap;
  final VoidCallback? onResetTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        final previousState = previous.keychainStateData.seedPhraseStateData;
        final currentState = current.keychainStateData.seedPhraseStateData;

        final sameShuffledWords = listEquals(
          previousState.shuffledWords,
          currentState.shuffledWords,
        );
        final sameUserWords = listEquals(
          previousState.userWords,
          currentState.userWords,
        );
        final sameIsResetWordsEnabled = previousState.isResetWordsEnabled ==
            currentState.isResetWordsEnabled;

        return !sameShuffledWords || !sameUserWords || !sameIsResetWordsEnabled;
      },
      builder: (context, state) {
        final stateData = state.keychainStateData.seedPhraseStateData;

        return _SeedPhraseWords(
          words: stateData.shuffledWords,
          userWords: stateData.userWords,
          onUserWordsChanged: onUserWordsChanged,
          onUploadTap: onUploadTap,
          onResetTap: onResetTap,
          isResetEnabled: stateData.isResetWordsEnabled,
        );
      },
    );
  }
}

class _SeedPhraseWords extends StatelessWidget {
  final List<String> words;
  final List<String> userWords;
  final ValueChanged<List<String>> onUserWordsChanged;
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
          _WordsActions(
            onUploadKeyTap: onUploadTap,
            onResetTap: onResetTap,
            isResetOffstage: !isResetEnabled,
          ),
        ],
      ),
    );
  }
}

class _WordsActions extends StatelessWidget {
  final VoidCallback? onUploadKeyTap;
  final VoidCallback? onResetTap;
  final bool isResetOffstage;

  const _WordsActions({
    this.onUploadKeyTap,
    this.onResetTap,
    this.isResetOffstage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesTextButton(
          onTap: onUploadKeyTap,
          child: Text(context.l10n.uploadCatalystKey),
        ),
        const Spacer(),
        Offstage(
          offstage: isResetOffstage,
          child: VoicesTextButton(
            onTap: onResetTap,
            child: Text(context.l10n.reset),
          ),
        ),
      ],
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        return previous
                .keychainStateData.seedPhraseStateData.areUserWordsCorrect !=
            current.keychainStateData.seedPhraseStateData.areUserWordsCorrect;
      },
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled:
              state.keychainStateData.seedPhraseStateData.areUserWordsCorrect,
        );
      },
    );
  }
}
