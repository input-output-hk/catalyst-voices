import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SeedPhrasePanel extends StatelessWidget {
  final SeedPhrase? seedPhrase;
  final bool isStoreSeedPhraseConfirmed;
  final bool isNextEnabled;

  const SeedPhrasePanel({
    super.key,
    required this.seedPhrase,
    required this.isStoreSeedPhraseConfirmed,
    required this.isNextEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _Body(
            words: seedPhrase?.mnemonicWords ?? [],
            onDownloadTap: _downloadSeedPhrase,
          ),
        ),
        const SizedBox(height: 10),
        _SeedPhraseStoredConfirmation(isConfirmed: isStoreSeedPhraseConfirmed),
        const SizedBox(height: 10),
        _Navigation(isNextEnabled: isNextEnabled),
      ],
    );
  }

  Future<void> _downloadSeedPhrase() async {}
}

class _Body extends StatelessWidget {
  final List<String> words;
  final VoidCallback? onDownloadTap;

  const _Body({
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
        final event = SeedPhraseStoreConfirmationEvent(value: value);
        RegistrationBloc.of(context).add(event);
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
            onTap: () {
              RegistrationBloc.of(context).add(const PreviousStepEvent());
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: VoicesNextButton(
            onTap: isNextEnabled
                ? () => RegistrationBloc.of(context).add(const NextStepEvent())
                : null,
          ),
        ),
      ],
    );
  }
}
