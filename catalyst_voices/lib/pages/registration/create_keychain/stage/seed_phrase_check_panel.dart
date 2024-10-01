import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SeedPhraseCheckPanel extends StatefulWidget {
  final SeedPhrase? seedPhrase;

  const SeedPhraseCheckPanel({
    super.key,
    this.seedPhrase,
  });

  @override
  State<SeedPhraseCheckPanel> createState() => _SeedPhraseCheckPanelState();
}

class _SeedPhraseCheckPanelState extends State<SeedPhraseCheckPanel> {
  final _seedPhraseWords = <String>[];
  final _shuffledSeedPhraseWords = <String>[];
  final _userWords = <String>[];

  bool get _isStageValid {
    if (_seedPhraseWords.isEmpty) {
      return false;
    }

    return listEquals(_seedPhraseWords, _userWords);
  }

  @override
  void initState() {
    super.initState();

    _updateSeedPhraseWords();
    _updateUserWords(_seedPhraseWords);
  }

  @override
  void didUpdateWidget(covariant SeedPhraseCheckPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.seedPhrase != oldWidget.seedPhrase) {
      _updateSeedPhraseWords();
      _updateUserWords(_seedPhraseWords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: VoicesLoadable(
            isLoading: _seedPhraseWords.isEmpty,
            builder: (context) {
              return _SeedPhraseWords(
                words: _shuffledSeedPhraseWords,
                userWords: _userWords,
                onUserWordsChanged: _onWordsSequenceChanged,
                onUploadTap: _uploadSeedPhrase,
                onResetTap: _clearUserWords,
                isResetEnabled: _userWords.isNotEmpty,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _Navigation(isNextEnabled: _isStageValid),
      ],
    );
  }

  Future<void> _uploadSeedPhrase() async {
    //
  }

  void _clearUserWords() {
    setState(_updateUserWords);
  }

  void _onWordsSequenceChanged(List<String> words) {
    setState(() {
      _updateUserWords(words);
    });
  }

  void _updateSeedPhraseWords() {
    final seedPhrase = widget.seedPhrase;
    final words = seedPhrase?.mnemonicWords ?? <String>[];
    final shuffledWords = seedPhrase?.shuffledMnemonicWords ?? <String>[];

    _seedPhraseWords
      ..clear()
      ..addAll(words);

    _shuffledSeedPhraseWords
      ..clear()
      ..addAll(shuffledWords);

    debugPrint('seedPhraseWords: $_seedPhraseWords');
  }

  void _updateUserWords([
    List<String> words = const [],
  ]) {
    _userWords
      ..clear()
      ..addAll(words);

    RegistrationCubit.of(context).setSeedPhraseCheckConfirmed(
      isConfirmed: _isStageValid,
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

class _Navigation extends StatelessWidget {
  final bool isNextEnabled;

  const _Navigation({
    this.isNextEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VoicesBackButton(
            onTap: () => RegistrationCubit.of(context).previousStep(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: VoicesNextButton(
            onTap: isNextEnabled
                ? () => RegistrationCubit.of(context).nextStep()
                : null,
          ),
        ),
      ],
    );
  }
}
