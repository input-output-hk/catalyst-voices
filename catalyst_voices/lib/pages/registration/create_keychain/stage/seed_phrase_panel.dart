import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SeedPhrasePanel extends StatefulWidget {
  final SeedPhrase? seedPhrase;
  final bool isStoreSeedPhraseConfirmed;
  final bool isNextEnabled;

  const SeedPhrasePanel({
    super.key,
    this.seedPhrase,
    required this.isStoreSeedPhraseConfirmed,
    required this.isNextEnabled,
  });

  @override
  State<SeedPhrasePanel> createState() => _SeedPhrasePanelState();
}

class _SeedPhrasePanelState extends State<SeedPhrasePanel> {
  final _seedPhraseWords = <String>[];

  @override
  void initState() {
    super.initState();
    RegistrationCubit.of(context).buildSeedPhrase();

    _updateWords();
  }

  @override
  void didUpdateWidget(covariant SeedPhrasePanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.seedPhrase != oldWidget.seedPhrase) {
      _updateWords();
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
                words: _seedPhraseWords,
                onDownloadTap: _downloadSeedPhrase,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _SeedPhraseStoredConfirmation(
          isConfirmed: widget.isStoreSeedPhraseConfirmed,
        ),
        const SizedBox(height: 10),
        RegistrationBackNextNavigation(isNextEnabled: widget.isNextEnabled),
      ],
    );
  }

  Future<void> _downloadSeedPhrase() async {
    await RegistrationCubit.of(context).downloadSeedPhrase();
  }

  void _updateWords() {
    _seedPhraseWords
      ..clear()
      ..addAll(widget.seedPhrase?.mnemonicWords ?? []);
  }
}

class _SeedPhraseWords extends StatelessWidget {
  final List<String> words;
  final VoidCallback? onDownloadTap;

  const _SeedPhraseWords({
    required this.words,
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SeedPhrasesViewer(words: words),
          const SizedBox(height: 10),
          VoicesTextButton(
            onTap: onDownloadTap,
            child: Text(context.l10n.createKeychainSeedPhraseDownload),
          ),
        ],
      ),
    );
  }
}

class _SeedPhraseStoredConfirmation extends StatelessWidget {
  final bool isConfirmed;

  const _SeedPhraseStoredConfirmation({
    this.isConfirmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: isConfirmed,
      label: Text(context.l10n.createKeychainSeedPhraseStoreConfirmation),
      onChanged: (value) {
        RegistrationCubit.of(context).confirmSeedPhraseStored(confirmed: value);
      },
    );
  }
}
