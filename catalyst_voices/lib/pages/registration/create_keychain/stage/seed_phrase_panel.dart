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
  @override
  void initState() {
    RegistrationCubit.of(context).buildSeedPhrase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _Body(
            words: widget.seedPhrase?.mnemonicWords,
            onDownloadTap: _downloadSeedPhrase,
          ),
        ),
        const SizedBox(height: 10),
        _SeedPhraseStoredConfirmation(
          isConfirmed: widget.isStoreSeedPhraseConfirmed,
        ),
        const SizedBox(height: 10),
        _Navigation(isNextEnabled: widget.isNextEnabled),
      ],
    );
  }

  Future<void> _downloadSeedPhrase() async {}
}

class _Body extends StatelessWidget {
  final List<String>? words;
  final VoidCallback? onDownloadTap;

  const _Body({
    this.words,
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    final words = this.words;

    if (words == null || words.isEmpty) {
      return const Center(child: VoicesCircularProgressIndicator());
    } else {
      return _SeedPhraseWords(
        words: words,
        onDownloadTap: onDownloadTap,
      );
    }
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
                ? () => RegistrationCubit.of(context).nextStep
                : null,
          ),
        ),
      ],
    );
  }
}
