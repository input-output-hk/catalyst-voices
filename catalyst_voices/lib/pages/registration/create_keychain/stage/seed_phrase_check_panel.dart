import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
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

  bool get _hasSeedPhraseWords => _seedPhraseWords.isNotEmpty;

  bool get _completedWordsSequence {
    return _hasSeedPhraseWords && _userWords.length == _seedPhraseWords.length;
  }

  bool get _completedCorrectlyWordsSequence {
    return _hasSeedPhraseWords && listEquals(_userWords, _seedPhraseWords);
  }

  @override
  void initState() {
    super.initState();

    _updateSeedPhraseWords();
    // Note. In debug mode we're prefilling correct seed phrase words
    // so its faster to test screens
    _updateUserWords(kDebugMode ? _seedPhraseWords : const []);
  }

  @override
  void didUpdateWidget(covariant SeedPhraseCheckPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.seedPhrase != oldWidget.seedPhrase) {
      _updateSeedPhraseWords();
      // Note. In debug mode we're prefilling correct seed phrase words
      // so its faster to test screens
      _updateUserWords(kDebugMode ? _seedPhraseWords : const []);
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
        RegistrationBackNextNavigation(isNextEnabled: _completedWordsSequence),
      ],
    );
  }

  Future<void> _uploadSeedPhrase() async {
    // TODO(damian-molinski): open upload dialog
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
  }

  void _updateUserWords([
    List<String> words = const [],
  ]) {
    _userWords
      ..clear()
      ..addAll(words);

    final isConfirmed = _completedCorrectlyWordsSequence;

    RegistrationCubit.of(context)
        .setSeedPhraseCheckConfirmed(isConfirmed: isConfirmed);
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
